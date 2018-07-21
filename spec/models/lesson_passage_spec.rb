require_relative 'models_helper'

RSpec.describe LessonPassage, type: :model do
  it { should belong_to(:lesson) }
  it { should belong_to(:course_passage) }
  it { should have_many(:quest_passages).dependent(:destroy) }
  it { should belong_to(:educable) }

  context '.create_quest_passages' do
    let(:course) { create(:course_master, :with_course_and_lessons).courses.last }
    let(:lesson) { course.lessons.last }
    let(:quests) { create_list(:quest, 3, lesson: lesson, author: lesson.author) }
    let!(:course_passage) do
      create(:course_passage, educable: course.author, course: course)
    end

    it 'create quest_passages' do
      expect{
        create(:lesson_passage,
               course_passage: course_passage,
               lesson: lesson,
               educable: course.author)
      }.to change(QuestPassage, :count).by(lesson.quest_groups.count)
    end

    it 'create quest_passage for each quest_group of lesson' do
      ids = create(
        :lesson_passage,
        course_passage: course_passage,
        lesson: lesson,
        educable: course.author).quest_passages.pluck(:quest_group_id)

      lesson.quest_groups.each do |quest_group|
        expect(ids).to be_include(quest_group.id)
      end
    end
  end
end
