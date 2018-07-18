require 'rails_helper'

RSpec.describe CoursePassage, type: :model do
  it { should belong_to(:educable) }
  it { should belong_to(:course) }
  it { should have_many(:lesson_passages) }

  context '.after_create_create_lesson_passage' do
    let!(:course) { create(:course_master, :with_course_and_lessons).courses.last }

    it 'create lesson_passages' do
      expect{
        create(:course_passage, course: course, educable: course.author)
      }.to change(LessonPassage, :count).by(course.lessons.count)
    end

    it 'create lesson_passage for each lesson of course' do
      lesson_passage_ids = create(
        :course_passage,
        course: course,
        educable: course.author
      ).lesson_passages.pluck(:lesson_id)

      course.lessons.each do |lesson|
        expect(lesson_passage_ids).to be_include(lesson.id)
      end
    end
  end
end
