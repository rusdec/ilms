module CourseHelper
  def learn_now(course, course_passage = nil)
    return unless current_user

    if current_user.learning?(course)
      return button_tag 'You learning it',  class: 'btn btn-outline-primary',
                                            disabled: true
    end
    course_passage = CoursePassage.new unless course_passage
    form_for course_passage, remote: true, format: :json do |f|
      concat(f.hidden_field :course_id, value: course.id)
      concat(f.submit 'Learn now!', class: 'btn btn-primary')
    end
  end
end
