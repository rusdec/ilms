require_relative 'models_helper'

RSpec.describe CoursePassage, type: :model do
  it { should belong_to(:educable) }
  it { should belong_to(:course) }
  it { should have_many(:lesson_passages).dependent(:destroy) }

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
  end # context '.after_create_create_lesson_passage'

  context '.validate_already_course_passage' do
    let!(:course) { create(:course_master, :with_course_and_lessons).courses.last }
    let(:user) { course.author }
    let(:new_course_passage) do
      build(:course_passage, course: course, educable: user)
    end

    context 'when user learning course' do
      before { create(:course_passage, course: course, educable: user) }

      it 'can\'t start learning it again' do
        expect(new_course_passage).to_not be_valid
      end
    end

    context 'when user passed course' do
      before do
        create(:course_passage, course: course, educable: user, passed: true)
      end

      it 'can start learning it again' do
        expect(new_course_passage).to be_valid
      end
    end

    context 'when user never took a course' do
      it 'can start learning it again' do
        expect(new_course_passage).to be_valid
      end
    end
  end

  context '#learning?' do
    let!(:user) { create(:course_master, :with_course_and_lessons) }
    let(:course) { user.courses.last }

    context 'when course in learning' do
      it 'should return true' do
        create(:course_passage, educable: user, course: course)
        expect(user).to be_learning(course)
      end
    end

    context 'when course not in learning' do
      it 'should return false' do
        expect(user).to_not be_learning(course)
      end
    end
  end
end
