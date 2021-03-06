require 'rails_helper'

describe '課題の詳細' do
  it do
    user = sign_up
    project = create_project(user, name: 'Project')

    issue = create_issue(user.as_member_of(project), title: '課題のタイトル', content: '課題の本文')

    sign_in(user)
    visit project_issue_path(project, issue)

    aggregate_failures do
      expect(find('#app_issue_title').text).to eq(issue.title)
      expect(find('#app_issue_content').text).to eq(issue.content)
      expect(find('#app_issue_author').text).to eq(user.name)
      expect(find('#app_issue_created_at').text).to eq(I18n.l(issue.created_at.to_date))

      expect(page).to_not have_css('#app_closed_issue')
      within('#app_issue_detail') do
        expect(page).to have_content('編集する', count: 2)
      end

      expect(page).to have_content('投稿する')
      expect(page).to have_content('解決済みにする')
    end
  end
end
