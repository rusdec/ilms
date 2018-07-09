require_relative '../../features_helper'

feature 'Show course', %q{
  As user
  I can see a detail course
  so that I can read detail information or edit it
} do

  given(:user) { create(:course_master) }
  given!(:course) { create(:course, :with_lessons, author: user) }
  
  context 'when author' do
    before do
      sign_in(user)
      visit course_master_course_path(course)
    end

    scenario 'see edit link' do
      expect(page).to have_link('Edit')
    end

    scenario 'see delete link' do
      expect(page).to have_link('Delete')
    end

    scenario 'see link add lesson' do
      expect(page).to have_link('Add lesson')
    end
  end

  context 'when not author' do
    before do
      sign_in(create(:course_master))
      visit course_master_course_path(course)
    end

    scenario 'no see edit link' do
      expect(page).to_not have_link('Edit')
    end

    scenario 'no see delete link' do
      expect(page).to_not have_link('Delete')
    end

    scenario 'no see add lesson link' do
      expect(page).to_not have_link('Add lesson')
    end
  end

  context 'when any user manage role' do
    scenario 'see link to lessons' do
      [user, create(:course_master)].each do |role|
        sign_in(role)
        visit course_master_course_path(course)

        course.lessons.each { |lesson| expect(page).to have_link(lesson.title) }
        sign_out
      end
    end

    scenario 'see detail info' do
      [user, create(:course_master)].each do |role|
        sign_in(role)
        visit course_master_course_path(course)

        [course.title,
         course.author.full_name,
         course.decoration_description,
         date_format(course.created_at),
        ].each { |text| expect(page).to have_content(text) }
        sign_out
      end
    end
  end
end 
