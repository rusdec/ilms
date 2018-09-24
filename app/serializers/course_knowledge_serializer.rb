class CourseKnowledgeSerializer < ActiveModel::Serializer
  attributes :id, :course_id, :percent
  attribute :knowledge

  def knowledge
    KnowledgeSerializer.new(object.knowledge)
  end
end
