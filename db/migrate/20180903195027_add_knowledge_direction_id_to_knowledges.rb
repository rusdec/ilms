class AddKnowledgeDirectionIdToKnowledges < ActiveRecord::Migration[5.2]
  def change
    add_reference :knowledges, :knowledge_direction, foreign_key: true
  end
end
