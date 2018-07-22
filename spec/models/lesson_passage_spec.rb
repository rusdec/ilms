require_relative 'models_helper'

RSpec.describe LessonPassage, type: :model do
  it { should belong_to(:lesson) }
  it { should belong_to(:course_passage) }
  it { should have_many(:quest_passages).dependent(:destroy) }
  it { should belong_to(:educable) }

  context 'private' do
    context '.create_quest_passages' do
      let(:course) { create(:course_master, :with_course_and_lessons).courses.last }
      let(:lesson) { course.lessons.last }
      let!(:quests) { create_list(:quest, 3, lesson: lesson, author: lesson.author) }
      let!(:course_passage) do
        create(:course_passage, educable: course.author, course: course)
      end
      let(:params) do
        { course_passage: course_passage, lesson: lesson, educable: course.author }
      end

      it 'create quest_passages' do
        expect{
          create(:lesson_passage, params)
        }.to change(QuestPassage, :count).by(quests.count)
      end

      it 'create quest_passage for each quest of lesson' do
        ids = create(:lesson_passage, params).quest_passages.pluck(:quest_id)
        quests.each { |quest| expect(ids).to be_include(quest.id) }
      end
    end
  end

  context '.quest_passages_by_quest_group' do
    let(:course) { create(:course_master, :with_full_course).courses.last }
    let(:lesson_passage) { course.course_passages.first.lesson_passages.first }

    it 'return array quest_passages by quest group' do
      quest_passages = lesson_passage.lesson.quest_groups.collect do |quest_group|
        lesson_passage.quest_passages.where(quest: quest_group.quests)
      end

      expect(lesson_passage.quest_passages_by_quest_group).to eq(quest_passages)
    end
  end
end
