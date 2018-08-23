class Lesson < ApplicationRecord
  has_closure_tree

  include Persistable
  include Passable
  include Authorable

  belongs_to :course

  has_many :quests, dependent: :destroy
  has_many :quest_groups
  has_many :materials, dependent: :destroy

  validates :title, presence: true
  validates :title, length: { minimum: 5, maximum: 50 }
  validates :order, numericality: { only_integer: true,
                                    greater_than_or_equal_to: 1 }

  # Passable Template method
  alias_attribute :passable_children, :quests
end
