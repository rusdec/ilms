class CoursePassage < ApplicationRecord
  belongs_to :educable, polymorphic: true
  belongs_to :course
  has_many :lesson_passages

  validate :validate_already_course_passage

  after_create :after_create_create_lesson_passage

  private

  def validate_already_course_passage
    if CoursePassage.find_by(educable: educable, course: course, passed: false)
      errors.add(:course, 'is already on your study')
    end
  end

  def after_create_create_lesson_passage
    course.lessons.map do |lesson|
      lesson_passages.create(
        educable: educable,
        lesson: lesson,
        course_passage: self
      )
    end
  end
end
