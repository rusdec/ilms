require_relative '../features_helper'

feature 'Course manage panel', %q{
  As Administrator or Course Master
  I can access to Course manage panel
  So that I can create and manage my courses
} do

  context 'Manage roles' do
    manage_roles.each do |role|
      describe "#{role}" do
        before { sign_in(create(role.underscore.to_sym)) }

        scenario 'can see manage link' do
          expect(page).to have_link('Manage courses')
        end

        scenario 'can open manage course page' do
          click_link('Manage courses')
          within '.container' do
            expect(page).to have_content('Manage courses')
          end
        end

        scenario 'see manage sections' do
          visit course_master_path

          %w(Courses Quests).each do |section|
            expect(page).to have_content(section)
          end
        end
      end
    end
  end

  context 'Not manage roles' do
    non_manage_roles.each do |role|
      describe "#{role}" do
        before { sign_in(create(role.underscore.to_sym)) }

        scenario 'can\'t see manage link' do
          expect(page).to_not have_link('Manage courses')
        end
      end
    end
  end
end
