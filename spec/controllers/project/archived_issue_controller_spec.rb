require 'rails_helper'

describe Project::ArchivedIssuesController do
  it do
    post :create, params: { project_id: 'dummy' }
    expect_ensure_signed_in
  end

  context do
    include_context '2人のユーザーがそれぞれプロジェクトを作成している'

    before { sign_in(user_b) }

    it do
      post :create, params: { project_id: project_a }
      expect_ensure_project_member
    end
  end
end