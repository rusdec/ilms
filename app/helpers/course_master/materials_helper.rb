module CourseMaster::MaterialsHelper
  def materials_path(material)
    "#{edit_course_master_lesson_path(material.lesson)}#materials"
  end
end
