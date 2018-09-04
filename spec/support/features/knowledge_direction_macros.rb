module Features
  module KnowledgeDirectionMacros
    def select_knowledge_direction(name)
      find(".knowledge-direction-item[data-name='#{name.downcase}']").click
    end

    def select_custom_knowledge_direction(name)
      fill_in 'new-knowledge-direction', with: name
      click_on 'add-new-knowledge-direction'
    end

    def back_to_knowledges
      click_on 'back-to-new-knowledge'
    end
  end
end
