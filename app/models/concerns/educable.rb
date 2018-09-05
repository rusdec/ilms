module Educable
  extend ActiveSupport::Concern

  included do
    has_many :passages, dependent: :destroy

    def learning?(passable)
      passages.all_in_progress.where(passable: passable).any?
    end

    def learned_courses
      passages.for_courses.collect { |passage| passage.course }.uniq
    end
  end
end
