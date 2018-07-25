class QuestSolution < ApplicationRecord
  include HtmlAttributable

  belongs_to :quest_passage

  html_attributes :body

  validates :body, html: { presence: true }

  scope :for_auditor, ->(user) do
    joins(quest_passage: :quest).where(quests: { user_id: user })
  end

  scope :unverified_for_auditor, ->(user) do
    for_auditor(user).where(quest_solutions: { verified: false })
  end

  scope :unverified, ->() { where(verified: false) }

  scope :declined, ->() { where(verified: true).where(passed: false) }

  validate :validate_unverification_solutions, on: :create

  def accept!
    verify!(true)
  end

  def decline!
    verify!(false)
  end

  private

  def validate_unverification_solutions
    if quest_passage.has_unverified_solutions?
      errors.add(:quest_solution, 'already created')
    end
  end

  def verify!(passed)
    verified? ? already_verified! : self.update!(passed: passed, verified: true)
  end

  def already_verified!
    errors.add(:quest_solution, 'already verified')
    ActiveRecord::RecordInvalid.new(self)
  end
end
