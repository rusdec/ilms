module CourseMaster::QuestHelper
  def radio_quest_group(params)
    group = params[:group]
    form = params[:form]

    checked = group.current_quest_group ? 'checked' : ''

    content_tag :div, class: 'form-check' do
      concat(form.radio_button :quest_group_id, group.id,
                               { class: 'form-check-input', checked: checked })
      concat(group_quests_to_links(group).join(', ').html_safe)
    end
  end

  def group_quests_to_links(group)
    if group.quests.empty?
      [t('helpers.quest.none')]
    else
      group.quests.map do |quest|
        link_to quest.title, course_master_quest_path(quest), target: '_blank' 
      end
    end
  end

  def alternative_quest_for_selector(params)
    params[:quest_groups].collect do |group|
      radio_quest_group(group: group, form: params[:form])
    end.join('').html_safe
  end

  def quests_path(quest)
    "#{edit_course_master_lesson_path(quest.lesson)}#quests"
  end
end
