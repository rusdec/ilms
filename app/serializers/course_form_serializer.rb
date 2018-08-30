class CourseFormSerializer < ActiveModel::Serializer
  attributes :id, :title, :level, :published,
             :decoration_description,
             :created_at, :updated_at, :free_knowledges

  has_many :course_knowledges do
    object.course_knowledges.map do |course_knowledge|
      CourseKnowledgeSerializer.new(course_knowledge)
    end
  end

  def free_knowledges
    object.free_knowledges.map do |free_knowledge|
      KnowledgeSerializer.new(free_knowledge)
    end
  end
end
