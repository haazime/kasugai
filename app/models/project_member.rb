class ProjectMember < ApplicationRecord
  belongs_to :project, touch: true
  belongs_to :user

  has_many :issue_appearances, dependent: :destroy

  delegate :email, to: :user
  delegate :name, to: :user
  delegate :initials, to: :user
  delegate :theme, to: :user

  class << self

    def for_project(project_id)
      where(project_id: project_id).order(:id)
    end

    def find_by_user_and_project(user_id, project_id)
      includes(user: :account)
        .find_by(user_id: user_id, project_id: project_id)
    end
  end

  def can_delete_member?(project_member)
    return false unless project.can_delete_member?
    self == project_member
  end

  def appear_in_issue(issue)
    return unless issue.project_id = project_id
    issue_appearances.create!(issue: issue)
  end

  def away_from_issue(issue)
    issue_appearances.find_by(issue_id: issue.id)&.destroy!
  end
end
