class UserKnowledgeDecorator < Draper::Decorator
  delegate_all

  def progress_bar
    percent = (level.to_f/max_level.to_f) * 100
    h.render partial: 'shared/progress_bar',
             locals: { percent: percent,
                       progress_color: h.progress_color(100) }
  end
end
