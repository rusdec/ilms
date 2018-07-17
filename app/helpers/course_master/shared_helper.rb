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

  def remote_links(model, resource = nil)
    resource ||= model.last
    model = [:course_master] + model
    yield_if_author(resource) do
      content_tag :span, class: 'remote-links small' do
        concat(link_to 'Edit', edit_polymorphic_path(model))
        concat(link_to 'Delete', polymorphic_path(model),
                                 class: "destroy_#{underscored_klass(resource)}",
                                 method: :delete,
                                 remote: true)
      end
    end
  end

  def editor_text_area(params)
    name = params[:name]
    form = params[:form]

    content_tag :div, class: "editor-container", id: "editor_#{name}"  do
      concat(form.label name)
      concat(tag.div class: 'toolbar')
      concat(tag.div class: 'editor')
      concat(form.hidden_field name, class: 'textarea')
    end
  end
end
