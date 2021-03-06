class Project::IssuesController < Project::BaseController
  layout 'project'

  before_action :ensure_signed_in
  before_action :ensure_project_member

  helper_method :current_issue

  def index
    @issue_list = current_project.issue_list
    @closed_issue_list = current_project.closed_issue_list
  end

  def show
    @issue = current_issue
    @issue_form = IssueForm.new(title: @issue.title, content: @issue.content)
    @comment_form = IssueCommentForm.new
  end

  def new
    @form = IssueForm.new
    @form.set_continue if params[:continue]
  end

  def create
    form = IssueForm.new(form_params)
    result = IssueService.create(current_project_member, form)
    if result.succeeded?
      redirect_after_create(form)
    else
      @form = result.params
      render :new
    end
  end

  def edit
    @form = IssueForm.fill(current_issue)
  end

  def update
    form = IssueForm.new(form_params)
    @result = IssueService.update(current_project_member, current_issue, form)
    if @result.succeeded?
      respond_to do |f|
        f.html { redirect_to project_issues_url, notice: flash_message }
        f.js
      end
    else
      @issue = current_issue
      @form = @result.params
      respond_to do |f|
        f.html { render :edit }
        f.js
      end
    end
  end

  def destroy
    IssueService.delete(current_project_member, current_issue)
    redirect_to project_issues_url, notice: flash_message
  end

  private

    def form_params
      params.require(:form).permit(:title, :content, :field, :continue)
    end

    def current_issue
      @current_issue ||= Issue.includes(:closed).find(params[:id])
    end

    def redirect_after_create(form)
      if form.continue?
        redirect_to new_project_issue_url(current_project, continue: 1)
      else
        redirect_to project_issues_url(current_project), notice: flash_message
      end
    end
end
