class QuestSolution < ApplicationRecord
  include HtmlAttributable

  belongs_to :quest_passage

  html_attributes :body

  validates :body, html: { presence: true }

  scope :for_auditor, ->(user) do
    joins(quest_passage: :quest).where(quests: { user_id: user })
  end

  scope :unverifieds_for_auditor, ->(user) do
    for_auditor(user).where(quest_solutions: { verified: false })
  end

  def accept!
    verify!(true)
  end

  def decline!
    verify!(false)
  end

  private

  def verify!(passed)
    verified? ? already_verified! : self.update!(passed: passed, verified: true)
  end

  def already_verified!
    errors.add(:quest_solution, 'already verified')
    ActiveRecord::RecordInvalid.new(self)
  end
end
