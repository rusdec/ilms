class CoursePassage < ApplicationRecord
  belongs_to :educable, polymorphic: true
  belongs_to :course
  has_many :lesson_passages

  after_create :after_create_create_lesson_passage

  private

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
