require_relative '../features_helper'

feature 'Course manage home page', %q{
  As Administrator or Course Master
  I can access to Course manage page
  So that I can manage my courses
} do

  context 'Manage roles' do
    manage_roles.each do |role|
      describe "#{role}" do
        let!(:user) { create(role.underscore.to_sym) }
        let!(:courses) { create_list(:course, 5, author: user) }

        before { sign_in(user) }

        scenario 'can see manage link' do
          expect(page).to have_link('Manage courses')
        end

        scenario 'can open manage course page' do
          click_link('Manage courses')
          expect(page).to have_content('Manage courses')
        end

        scenario 'see manage sections' do
          visit course_master_path

          ['Courses', 'Quest solutions'].each do |section|
            expect(page).to have_content(section)
          end

          [
            "total: #{courses.count}",
            "unverified: 0"
          ].each do |info|
            expect(page).to have_content(info)
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
