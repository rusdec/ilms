require 'rails_helper'

RSpec.describe LessonPassage, type: :model do
  it { should belong_to(:educable) }
  it { should belong_to(:lesson) }
  it { should belong_to(:course_passage) }

  context '.is_available?' do
    let(:course) { create(:course_master, :with_course_and_lessons).courses.last }
    let(:course_passage) do
      create(:course_passage, course: course, educable: course.author)
    end
    let!(:lesson_passages) { course_passage.lesson_passages }

    it 'root lesson return true' do
      expect(lesson_passages.first).to be_is_available
    end

    it 'available lesson return true' do
      lesson_passage = lesson_passages.last
      lesson_passage.available = true
      expect(lesson_passage).to be_is_available
    end
  end
end
