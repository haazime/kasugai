require 'rails_helper'

describe '課題の追加' do
  let(:user) { sign_up }
  let(:project) { create_project(user, name: 'ABC') }

  before do
    sign_in(user)
    visit new_project_issue_path(project_id: project.id)
  end

  it do
    fill_in 'form[title]', with: '課題ABC'
    fill_in 'form[content]', with: '課題本文'
    click_on '作成する'

    aggregate_failures do
      expect(page).to have_content('課題を作成しました')
      expect(page).to have_content('課題ABC')
    end
  end

  it do
    click_on '作成する'
    expect(page).to have_content('タイトルを入力してください')
  end
end