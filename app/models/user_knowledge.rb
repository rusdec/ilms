class UserKnowledge < ApplicationRecord
  belongs_to :user, polymorphic: true
  belongs_to :knowledge

  validates :knowledge_id, uniqueness: { scope: :user_id,
                                         message: 'should be once per user' }
end
