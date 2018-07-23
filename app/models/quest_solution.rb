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
    transaction do
      self.update!(passed: true)
      verify!
    end
  end

  def decline!
    transaction do
      self.update!(passed: false)
      verify!
    end
  end

  private

  def verify!
    self.update!(verified: true)
  end
end
