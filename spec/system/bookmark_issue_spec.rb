require 'rails_helper'

describe '課題のブックマーク', type: :system do
  it do
    user = sign_up
    project = create_project(user, name: 'Project')
    issue_a = create_issue(user.as_member_of(project), title: '課題A')
    issue_b = create_issue(user.as_member_of(project), title: '課題B')
    issue_c = create_issue(user.as_member_of(project), title: '課題C')

    sign_in(user)

    visit project_issues_path(project)
    within("#app_issue_#{issue_b.id}") do
      first('.app_bookmark').click
      expect(page).to have_css('.iss-Bookmark-on')
    end

    visit project_path(project)
    within("#app_bookmarked_issues") do
      expect(page).to have_content(issue_b.title)
    end

    visit project_issue_path(project, issue_a)
    first('.app_bookmark').click
    expect(page).to have_css('.iss-Bookmark-on')
  end
end
