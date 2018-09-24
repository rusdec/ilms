require_relative '../features_helper'

feature 'Show course', %q{
  As User
  I can view a course page
  so that I can see details of course
} do

  let(:user) { UserDecorator.decorate(create(:user)) }
  let!(:course) do
      create(:course, :with_lessons, author: create(:course_master)).decorate
  end
  
  context 'when course is publicated' do
    before do
      sign_in(user)
      visit course_path(course, locale: I18n.locale)
    end

    scenario 'see details of course ' do
      # count 2: page title, breadcrumb
      expect(page).to have_content(course.title, count: 2)
      expect(page).to have_content(course.author.full_name)
      expect(page).to have_content('Author')
      expect(page).to have_content("Difficulty: #{course.difficulty}")
      course.course_knowledges do |course_knowledge|
        expect(page).to have_content(course_knowledge.knowledge.name)
        expect(page).to have_content("#{course_knowledge.percent}%")
      end
    end

    scenario 'see lessons of course' do
      expect(page).to have_content('Lessons')
      course.lessons.each { |lesson| expect(page).to have_content(lesson.title) }
    end

    scenario 'see description' do
      expect(page).to have_content('Description')
      expect(page).to have_content(course.decoration_description)
    end

    scenario 'see learn now! link' do
      expect(page).to have_button('Learn now!')
    end
  end # context 'when course is publicated'

  context 'when course is not publicated' do
    before do
      sign_in(user)
      course.update(published: false)
      visit course_path(course, locale: I18n.locale)
    end

    scenario 'see error' do
      expect(page).to have_content('Access denied')
      expect(page).to_not have_content(course.title)
      expect(page).to_not have_button('Learn now!')
    end
  end #  context 'when course is not publicated'

  scenario 'user see breadcrumbs' do
    visit course_path(course, locale: I18n.locale)

    within '.breadcrumb' do
      expect(page).to have_link('Courses')
      expect(page).to have_content(course.title)
    end
  end # scenario 'user see breadcrumbs'
end
