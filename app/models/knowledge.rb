class Knowledge < ApplicationRecord
  has_many :course_knowledges, dependent: :destroy, inverse_of: :knowledge
  has_many :courses, through: :course_knowledges

  before_validation :downcase_name

  validates :name, presence: true
  validates :name, uniqueness: true
  validates :name, length: { minimum: 3, maximum: 50 }

  default_scope { order(:name) }

  protected

  def downcase_name
    name&.downcase!
  end
end
