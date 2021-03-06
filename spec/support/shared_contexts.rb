shared_context '2人のユーザーがそれぞれプロジェクトを作成している' do
  let(:user_a) { sign_up }
  let(:user_b) { sign_up }
  let(:project_a) { create_project(user_a, name: 'The primary users project') }
  let(:project_b) { create_project(user_b, name: 'The other users project') }
  let(:member_a) { user_a.as_member_of(project_a) }
  let(:member_b) { user_b.as_member_of(project_b) }

  before do
    user_a
    user_b
    project_a
    project_b
  end
end

shared_context '2人のユーザーがそれぞれのプロジェクトで課題を作成している' do
  include_context '2人のユーザーがそれぞれプロジェクトを作成している'

  let(:issue_a) { create_issue(member_a, title: 'Issue for project A') }
  let(:issue_b) { create_issue(member_b, title: 'Issue for project B') }

  before do
    issue_a
    issue_b
  end
end
