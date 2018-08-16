module BadgeAuthor
  extend ActiveSupport::Concern

  included do
    has_many :created_badges, class_name: 'Badge', as: :user
  end
end
