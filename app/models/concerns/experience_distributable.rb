module ExperienceDistributable
  def destribute_experience_between_knowledges
    transaction do
      course_knowledges.each do |course_knowledge|
        destribute_experience_for(
          course_knowledge.knowledge_id,
          course_knowledge.experience_rate_from(experience)
        )
      end
    end
  end

  protected

  def course_knowledges
    quest.course.course_knowledges
  end

  def experience
    quest.course.difficulty * quest.lesson.difficulty * quest.difficulty
  end


  def destribute_experience_for(knowledge_id, experience)
    user.user_knowledges.find_by(knowledge_id: knowledge_id)&.add_experience!(experience)
  end
end
