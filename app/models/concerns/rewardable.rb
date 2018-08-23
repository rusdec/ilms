module Rewardable
  extend ActiveSupport::Concern

  included do
    has_many :user_grantables, dependent: :destroy
    has_many :badges, through: :user_grantables, source: :grantable, source_type: 'Badge'
    
    def collected_course_badges(course)
      Badge.joins(:user_grantables)
        .where(user_grantables: { user: self })
        .where(badges: { course_id: course })
    end

    def collected_course_hidden_badges(course)
      collected_course_badges(course).hiddens
    end

    def reward!(grantable)
      user_grantables.create(grantable: grantable)
    end
  end
end
