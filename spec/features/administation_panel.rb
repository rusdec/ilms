require_relative 'features_helper'

feature 'Administration panel', %q{
  As Administrator
  I can access to Administration panel
  So that I can use other admin actions
} do
  describe 'Administrator' do
    before { sign_in(create(:admin)) }

    scenario 'can see manage link' do
      expect(page).to have_link('Administration')
    end
  end

  describe 'Course Master' do
    before { sign_in(create(:course_master)) }

    scenario 'can\'t see manage link' do
      expect(page).to_not have_link('Administration')
    end
  end

  describe 'User' do
    before { sign_in(create(:user)) }

    scenario 'can\'t see manage link' do
      expect(page).to_not have_link('Administration')
    end
  end
end
