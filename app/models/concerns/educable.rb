module Educable
  extend ActiveSupport::Concern

  included do
    has_many :passages, dependent: :destroy

    has_many :passaged_courses, through: :passages, source: :passable, source_type: 'Course'
    has_many :passaged_lessons, through: :passages, source: :passable, source_type: 'Lesson'
    has_many :passaged_quests,  through: :passages, source: :passable, source_type: 'Quest'

    has_many :passed_passages, -> { where(status: :passed) }, class_name: 'Passage'
    has_many :passed_courses, through: :passed_passages, source: :passable, source_type: 'Course'
    has_many :passed_lessons, through: :passed_passages, source: :passable, source_type: 'Lesson'
    has_many :passed_quests,  through: :passed_passages, source: :passable, source_type: 'Quest'

    has_many :in_progress_passages, -> { where(status: :in_progress) }, class_name: 'Passage'
    has_many :in_progress_courses, through: :in_progress_passages, source: :passable, source_type: 'Course'
    has_many :in_progress_lessons, through: :in_progress_passages, source: :passable, source_type: 'Lesson'
    has_many :in_progress_quests,  through: :in_progress_passages, source: :passable, source_type: 'Quest'

    has_many :unavailable_passages, -> { where(status: :unavailable) }, class_name: 'Passage'
    has_many :unavailable_lessons, through: :unavailable_passages, source: :passable, source_type: 'Lesson'

    def learning?(passable)
      in_progress_passages.where(passable: passable).any?
    end
  end
end
