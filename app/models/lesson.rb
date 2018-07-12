class Lesson < ApplicationRecord
  has_closure_tree

  include Persistable

  belongs_to :course
  belongs_to :author, foreign_key: :user_id, class_name: 'User'

  has_many :quests
  accepts_nested_attributes_for :quests, update_only: true

  validates :title, presence: true
  validates :title, length: { minimum: 5, maximum: 50 }
  validates :order, numericality: { only_integer: true,
                                    greater_than_or_equal_to: 1 }

  def safe_update(params)
    transaction do
      author.quests.update_lesson_id(params[:unused_quests], id)
      params.delete(:unused_quests) if params[:unused_quests]
      update!(params)
    end
  end
end
