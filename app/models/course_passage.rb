class CoursePassage < ApplicationRecord
  belongs_to :educable, polymorphic: true
  belongs_to :course
  has_many :lesson_passages, dependent: :destroy

  validate :validate_already_course_passage

  after_create :after_create_create_lesson_passage


  def self.learning?(course)
    where(course: course, passed: false).any?
  end

  private

  def validate_already_course_passage
    if CoursePassage.find_by(educable: educable, course: course, passed: false)
      errors.add(:course, 'in the process of learning')
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
