class CoursePassage < ApplicationRecord
  belongs_to :educable, polymorphic: true
  belongs_to :course

  has_many :lesson_passages, dependent: :destroy

  validate :validate_already_course_passage

  after_create :create_root_lesson_passages

  def self.learning?(course)
    where(course: course, passed: false).any?
  end

  private

  def validate_already_course_passage
    if CoursePassage.find_by(educable: educable, course: course, passed: false)
      errors.add(:course, 'in the process of learning')
    end
  end

  def create_root_lesson_passages
    create_lesson_passages(course.lessons.roots)
  end

  def create_lesson_passages(lessons)
    transaction do
      lessons.each do |lesson|
        lesson_passages.create!(lesson: lesson, educable: educable)
      end
    end
  end
end
