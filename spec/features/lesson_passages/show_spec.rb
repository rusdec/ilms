require_relative '../features_helper'

feature 'Show lesson_passage page', %q{
  As student
  I can view lesson materials
  so that I can learn it
} do

  given(:user) { create(:course_master, :with_full_course) }
  given(:lesson_passage) { user.passages.for_lessons.first }
  given(:lesson) { lesson_passage.passable }
  given(:params) { { id: lesson_passage } }

  context 'when authenticated user' do
    context 'when owner of course_passage' do
      before do
        sign_in(user)
        visit passage_path(lesson_passage)
      end

      scenario 'see lesson details' do
        %i(title ideas summary check_yourself).each do |field|
          expect(page).to have_content(lesson.send field)
        end
      end

      scenario 'see quests' do
        lesson_passage.children.each do |quest_passage|
          expect(page).to have_content(quest_passage.passable.title)
          expect(page).to have_content(quest_passage.passable.description.truncate(150))
          expect(page).to have_content("Level: #{quest_passage.passable.level}")
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
        user.passages.for_lessons.each do |lesson_passage|
          expect(page).to have_content(lesson_passage.passable.title)
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
        visit passage_path(lesson_passage)
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
    before { visit passage_path(lesson_passage) }

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
