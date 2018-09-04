module Features
  module KnowledgeMacros
    def select_knowledge(name)
      find(".knowledge-item[data-name='#{name.downcase}']").click
    end

    def set_percent_for_knowledge(name, percent = 0, order = 0)
      within(".course-knowledge-item[data-name='#{name.downcase}']") do
        fill_in "course_course_knowledges_attributes_#{order}_percent", with: percent
      end
    end

    def mark_for_delete(name, order = 0)
      within(".course-knowledge-item[data-name='#{name.downcase}']") do
        check("course_course_knowledges_attributes_#{order}__destroy")
      end
    end

    def select_custom_knowledge(name)
      fill_in 'new-knowledge', with: name
      click_on 'move-to-knowledge-directions'
    end

    def cancel_knowledge(name)
      within(".course-knowledge-item[data-name='#{name.downcase}']") do
        find('.remove-knowledge').click
      end
    end

    def selected_knowledges
      '.course-knowledge-items'
    end

    def free_knowledges
      '#knowledge-items'
    end
  end
end
