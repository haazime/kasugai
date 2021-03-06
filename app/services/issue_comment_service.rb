class IssueCommentService < ApplicationService

  def initialize(notifier: IssueCommentNotificationJob, broadcaster: IssueCommentBroadcastJob)
    @notifier = notifier
    @broadcaster = broadcaster
  end

  def post(project_member, issue, params)
    return failure(params: params) unless params.valid?

    comment = issue.comments.build(user_id: project_member.user_id, content: params.content)
    transaction do
      comment.save!
      IssueUpdatePropagationJob.perform_later(issue)
      ProjectActivities::IssueComment.record!(:posted, project_member, issue, params.content)
    end

    @broadcaster.perform_later(comment)
    @notifier.perform_later(comment)

    success(comment: comment)
  end

  def update(comment, params)
    return failure(params: params) unless params.valid?

    comment.content = params.content
    comment.save!
    success(comment: comment)
  end

  def delete(comment)
    transaction do
      comment.destroy!
      IssueUpdatePropagationJob.perform_later(comment.issue)
    end
  end
end
