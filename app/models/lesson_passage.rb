class LessonPassage < ApplicationRecord
  belongs_to :lesson
  belongs_to :educable, polymorphic: true
  belongs_to :course_passage

  def is_available?
    available? || lesson.root?
  end
end
