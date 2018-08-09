class PassageSolution < ApplicationRecord
  include HtmlAttributable
  include Statusable

  belongs_to :passage

  html_attributes :body

  validates :body, html: { presence: true }

  # Auditor role move to user
  #scope :for_auditor, ->(user) do
  #  joins(passage: :passable).where(passable: { user_id: user })
  #end

  # Auditor role move to user
  #scope :unverified_for_auditor, ->(user) do
  #  for_auditor(user).where(quest: { status: Status.unverified })
  #end

  validate :validate_unverification_solutions, on: :create

  protected

  # Statusable Template methor
  def default_status
    Status.unverified
  end

  def validate_unverification_solutions
    if passage.has_unverified_solutions?
      errors.add(:passage_solution, 'already created')
    end
  end

  def before_status_change
    already_verified! if verified?
  end

  def already_verified!
    errors.add(:passage_solution, 'already verified')
    ActiveRecord::RecordInvalid.new(self)
  end
end
