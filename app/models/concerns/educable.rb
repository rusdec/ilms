module Educable
  extend ActiveSupport::Concern

  included do
    has_many :course_passages, as: :educable, dependent: :destroy
    has_many :lesson_passages, as: :educable
  end
end
