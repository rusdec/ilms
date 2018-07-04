require_relative 'features_helper'

feature 'Course manage panel', %q{
  As Administrator or Course Master
  I can access to Course manage panel
  So that I can create and manage my courses
} do
  describe 'Administrator' do
    before { sign_in(create(:administrator)) }

    scenario 'can see manage link' do
      expect(page).to have_link('Manage courses')
    end
  end

  describe 'Course Master' do
    before { sign_in(create(:course_master)) }

    scenario 'can see manage link' do
      expect(page).to have_link('Manage courses')
    end
  end

  describe 'User' do
    before { sign_in(create(:user)) }

    scenario 'can\'t see manage link' do
      expect(page).to_not have_link('Manage courses')
    end
  end
end
