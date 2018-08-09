module Educable
  extend ActiveSupport::Concern

  included do
    has_many :passages, dependent: :destroy

    def learning?(passable)
      passages.all_in_progress.where(passable: passable).any?
    end
  end
end
