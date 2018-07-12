module CourseMaster::SharedHelper
  def secondary_button(params)
    link_to params[:text], params[:path], class: 'btn btn-secondary'
  end

  def submit_button(params)
    text = params[:resourse].persisted? ? 'Update' : 'Create'
  end

  def page_title(title = '')
    column_title = content_tag :div, class: 'col text-center' do
      concat(tag.h2 title, class: 'page-title')
    end

    content_tag :div, class: 'row' do
      concat(column_title)
    end
  end
end
