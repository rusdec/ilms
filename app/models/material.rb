class Material < ApplicationRecord
  include Authorable

  belongs_to :lesson

  default_scope { order(:order, :created_at) }

  validates :title, presence: true
  validates :title, length: { minimum: 3, maximum: 150 }

  validates :body, html: { presence: true,
                           length: { minimum: 10 } }

  validates :order, numericality: { only_integer: true,
                                    greater_than_or_equal_to: 1 }
end
