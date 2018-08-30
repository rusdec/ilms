class CourseKnowledgeDecorator < Draper::Decorator

  delegate_all

  def progress_bar
    h.render partial: 'shared/progress_bar',
             locals: { percent: percent,
                       progress_color: h.progress_color(percent) }
  end
end
