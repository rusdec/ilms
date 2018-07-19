require_relative '../features_helper'

feature 'Show lesson_passage page', %q{
  As student
  I can view lesson materials
  so that I can learn it
} do

  given(:user) { create(:course_master, :with_full_course) }
  given(:course_passage) { user.course_passages.last }
  given(:lesson_passage) { course_passage.lesson_passages.first }
  given(:lesson) { lesson_passage.lesson }
  given(:params) do
    { course_passage_id: course_passage, id: lesson_passage }
  end

  context 'when authenticated user' do
    context 'when owner of course_passage' do
      before do
        sign_in(user)
        visit course_passage_lesson_path(course_passage, lesson_passage)
      end

      scenario 'see lesson details' do
        %i(title ideas summary check_yourself).each do |field|
          expect(page).to have_content(lesson.send field)
        end
      end

      context 'see anchor links' do
        scenario 'to lessons details' do
          ['Ideas', 'Lesson summary', 'Check yourself'].each do |link|
            expect(page).to have_link(link)
          end
        end

        scenario 'to materials' do
          lesson.materials.each do |material|
            expect(page).to have_link(material.title)
          end
        end
      end

      scenario 'see materials' do
        lesson.materials.each do |material|
          %i(title body summary).each do |field|
            expect(page).to have_content(material.send field)
          end
        end
      end

      scenario 'can back to course_passage' do
        click_on 'Back'
        course_passage.lesson_passages.each do |lesson_passage|
          expect(page).to have_content(lesson_passage.lesson.title)
        end
        lesson.materials.each do |material|
          %i(title body summary).each do |field|
            expect(page).to_not have_content(material.send field)
          end
        end
      end
    end

    context 'when not owner of course_passage' do
      before do
        sign_in(create(:user))
        visit course_passage_lesson_path(course_passage, lesson_passage)
      end

      it 'see error' do
        expect(page).to have_content('Access denied')
      end

      it 'no see materials' do
        lesson.materials.each do |material|
          %i(title body summary).each do |field|
            expect(page).to_not have_content(material.send field)
          end
        end

        %i(title ideas summary check_yourself).each do |field|
          expect(page).to_not have_content(lesson.send field)
        end
      end
    end
  end

  context 'when not authenticated user' do
    before { visit course_passage_lesson_path(course_passage, lesson_passage) }

    it 'see sign in page' do
      expect(page).to have_button('Log in')
    end

    it 'no see materials' do
      lesson.materials.each do |material|
        %i(title body summary).each do |field|
          expect(page).to_not have_content(material.send field)
        end
      end

      %i(title ideas summary check_yourself).each do |field|
        expect(page).to_not have_content(lesson.send field)
      end
    end
  end
end
