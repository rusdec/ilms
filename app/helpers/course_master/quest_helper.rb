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
    quests = params[:group].quests
    quest = params[:quest]
    group = params[:group]

    content_tag :div, class: 'form-check' do
      concat(params[:form].radio_button :quest_group_id, group.id,
                                        { class: 'form-check-input',
                                          checked: quests.include?(quest) })
      concat(quests_to_links(quest, group.quests).join(', ').html_safe)
    end
  end

  def quests_to_links(current_quest, quests)
    quests = quests.reject { |q| q == current_quest }
    if quests.empty?
      ['none']
    else
      quests.map do |quest|
        link_to quest.title, course_master_quest_path(quest), target: '_blank' 
      end
    end
  end

  def selector_with_quest_alternatives(params)
    quest = params[:quest]
    quest_groups = quest.lesson.quest_groups
    return if quest_groups.empty?
    
    quest_groups.new if quest&.has_alternatives? || !quest.persisted?
    
    groups = quest_groups.collect do |group|
      radio_quest_group(list: quests_to_links(quest, group.quests),
                        group: group,
                        quest: quest,
                        form: params[:form])
    end
    
    groups.join('').html_safe
  end
end
