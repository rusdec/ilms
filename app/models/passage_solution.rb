class PassageSolution < ApplicationRecord
  include Statusable

  paginates_per 10

  belongs_to :passage

  validates :body, html: { presence: true }

  # @param [CourseMaster|Administrator] :user any user with course_master abilities
  # @param [Symbol] :type pluralized type of any Solutionable
  #
  # ==== Examples
  #
  #   PassageSolution.for_auditor(CourseMaster.last, :quests)
  scope :for_auditor, ->(user, type) do
    joins(:passage)
      .joins("JOIN #{type} ON passages.passable_id = #{type}.id")
      .where(type => { user_id: user.id })
  end

  scope :unverified_for_auditor, ->(user, type) do
    for_auditor(user, type).where(status: :unverified)
  end

  validate :validate_unverification_solutions, on: :create

  protected

  # Statusable Template method
  def after_update_status_hook
    passage.try_chain_pass! if accepted?
  end

  # Statusable Template method
  def default_status
    :unverified
  end

  def validate_unverification_solutions
    if passage.has_unverified_solutions?
      errors.add(:passage_solution, 'already created')
    end
  end
end
