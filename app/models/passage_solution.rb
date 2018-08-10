class PassageSolution < ApplicationRecord
  include HtmlAttributable
  include Statusable

  belongs_to :passage

  html_attributes :body

  validates :body, html: { presence: true }

  # Scopes `for_auditor` and `unverified_for_auditor`
  # are only for quests becouse courses and lessons
  # don\'t need manual verification
  scope :for_auditor, ->(user) do
    joins(:passage)
      .joins('JOIN quests ON passages.passable_id = quests.id')
      .where(quests: { user_id: user.id })
  end

  scope :unverified_for_auditor, ->(user) do
    for_auditor(user).where(status: Status.unverified)
  end

  validate :validate_unverification_solutions, on: :create

  protected

  # Statusable Template method
  def default_status
    statuses.unverified
  end

  def validate_unverification_solutions
    if passage.has_unverified_solutions?
      errors.add(:passage_solution, 'already created')
    end
  end
end
