module Authorable
  extend ActiveSupport::Concern

  included do
    belongs_to :author, foreign_key: :user_id, class_name: 'User'
  end
end
