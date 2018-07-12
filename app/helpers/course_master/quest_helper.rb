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

end
