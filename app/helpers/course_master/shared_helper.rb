module CourseMaster::SharedHelper
  def secondary_button(params)
    link_to params[:text], params[:path], class: 'btn btn-secondary'
  end

  def submit_button(params)
    text = params[:resourse].persisted? ? 'Update' : 'Create'
  end
end
