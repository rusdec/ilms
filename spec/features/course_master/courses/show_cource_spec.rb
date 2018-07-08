require_relative '../../features_helper'

feature 'Show course', %q{
  As user
  I can see a detail course
  so that I can read detail information or edit it
} do

  let(:user) { create(:course_master) }
  let!(:course) { create(:course, user_id: user.id) }
  
  context 'Author' do
    before do
      sign_in(user)
      visit course_master_course_path(course)
    end

    scenario 'can view detail page' do
      [course.title,
       course.author.full_name,
       course.decoration_description,
       date_format(course.created_at),
      ].each { |text| expect(page).to have_content(text) }
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

    scenario 'see link to lessons' do
      lessons = create_list(:lesson, 5, author: user, course: course)
      refresh
      lessons.each { |lesson| expect(page).to have_link(lesson.title) }
    end
  end

  context 'Not author' do
    before do
      sign_in(create(:course_master))
      visit course_master_course_path(course)
    end

    scenario 'can view detail page' do
      [course.title,
       course.author.full_name,
       course.decoration_description,
       date_format(course.created_at),
      ].each { |text| expect(page).to have_content(text) }
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

    scenario 'see link to lessons' do
      lessons = create_list(:lesson, 5, author: user, course: course)
      refresh
      lessons.each { |lesson| expect(page).to have_link(lesson.title) }
    end
  end
end 
