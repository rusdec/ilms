module CourseMaster::BadgesHelper
  def badges_path(badge)
    "#{edit_course_master_course_path(badge.course)}#badges"
  end
end
