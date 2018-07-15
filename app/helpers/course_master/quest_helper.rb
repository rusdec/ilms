module CourseMaster::QuestHelper
  def quest_remote_links(quest)
    yield_if_author(quest) do
      content_tag :span, class: 'remote-links small' do
        concat(link_to 'Edit', edit_course_master_quest_path(quest))
        concat(link_to 'Delete', course_master_quest_path(quest),
                                 class: "destroy_quest",
                                 method: :delete,
                                 remote: true)
      end
    end
  end

  def quest_alternatives(current_quest)
    ul_with_quests(current_quest.alternatives)
  end

  def ul_with_quests(quests)
    quests = quests.collect do |quest|
      content_tag :li do
        concat(link_to quest.title, course_master_quest_path(quest), target: '_blank')
      end
    end

    if quests.empty?
      tag.span('none')
    else
      content_tag :ul do
        concat(quests.join('').html_safe)
      end
    end
  end

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
      ['none']
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
end
