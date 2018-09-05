class UserDecorator < Draper::Decorator
  include HasCards
  include HasDate

  delegate_all

  decorates_association :user_knowledges

  def initials
    "#{name.first}#{surname.first}".upcase
  end

  def full_name
    "#{name} #{surname}"
  end

  def collected_course_hidden_badges_progress_card(course)
    collected = collected_course_hidden_badges(course).count
    total = course.badges.object.hiddens.count

    progress_card(
      title: 'Hidden Badges',
      body: "#{collected} from #{total}",
      percent: "#{(collected.to_f/total.to_f) * 100}"
    )
  end

  def collected_course_badges_progress_card(course)
    collected = collected_course_badges(course).count
    total = course.badges.count

    progress_card(
      title: 'Badges',
      body: "#{collected} from #{total}",
      percent: "#{(collected.to_f/total.to_f) * 100}"
    )
  end
end
