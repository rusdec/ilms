class QuestDecorator < Draper::Decorator
  delegate_all

  decorates_association :author
  decorates_association :lesson

  def title_preview
    object.title.truncate(30)
  end
end