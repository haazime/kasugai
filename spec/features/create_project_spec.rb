require 'rails_helper'

describe 'プロジェクトの作成' do
  let(:user) { sign_up }

  before do
    sign_in(user)
    visit new_project_path
  end

  it do
    fill_in 'form[name]', with: 'Project A'
    fill_in 'form[description]', with: 'New project'
    click_on '作成する'

    aggregate_failures do
      expect(page).to have_content('プロジェクトを作成しました')
      expect(page).to have_content('Project A')
      expect(page).to have_content('New project')
    end
  end

  it do
    click_on '作成する'
    expect(page).to have_content('プロジェクト名を入力してください')
  end
end
