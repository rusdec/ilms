class QuestSolution < ApplicationRecord
  include HtmlAttributable

  belongs_to :quest_passage

  html_attributes :body

  validates :body, html: { presence: true }
end
