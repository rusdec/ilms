class KnowledgeDirection < ApplicationRecord
  before_validation :downcase_name

  has_many :knowledges, inverse_of: :direction

  validates :name, presence: true
  validates :name, uniqueness: true
  validates :name, length: { minimum: 3, maximum: 50 }

  protected

  def downcase_name
    name&.downcase!
  end
end
