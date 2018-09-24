class Knowledge < ApplicationRecord
  has_many :course_knowledges, dependent: :destroy, inverse_of: :knowledge
  has_many :courses, through: :course_knowledges

  has_many :user_knowledges, dependent: :destroy
  has_many :users, through: :user_knowledges

  belongs_to :direction, foreign_key: :knowledge_direction_id,
             optional: true, class_name: 'KnowledgeDirection'

  before_validation :downcase_name

  validates :name, presence: true
  validates :name, uniqueness: true
  validates :name, length: { minimum: 3, maximum: 50 }

  default_scope { order(:name) }

  scope :new_for, ->(knowledgable) {
    where.not(id: knowledgable.send(:knowledges).pluck(:id))
  }

  protected

  def downcase_name
    name&.downcase!
  end
end
