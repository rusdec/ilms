module CourseMaster::SharedHelper
  def page_title(title = '')
    column_title = content_tag :div, class: 'col text-center' do
      concat(tag.h2 title, class: 'page-title')
    end

    content_tag :div, class: 'row mb-3' do
      concat(column_title)
    end
  end

  def remote_links(model, resource = nil)
    model.map! { |m| m.decorated? ? m.object : m}
    resource ||= model.last
    model = [:course_master] + model
    yield_if_author(resource) do
      content_tag :span, class: 'remote-links small' do
        concat(link_to icon(:fas, 'edit'), edit_polymorphic_path(model),
                       class: 'edit')
        concat(link_to icon(:fas, 'trash-alt'), polymorphic_path(model),
                       class: "destroy_#{underscored_klass(resource)} destroy",
                       method: :delete,
                       remote: true)
      end
    end
  end

  def editor_text_area(params)
    name = params[:name]
    form = params[:form]

    editor = content_tag :div, class: 'card' do
      concat(tag.div class: 'editor')
    end

    content_tag :div, class: 'editor-container', id: "editor_#{name}"  do
      concat(form.label name) unless params[:without_title]
      concat(tag.div class: 'toolbar')
      concat(editor)
      concat(form.hidden_field name, class: 'textarea')
    end
  end
end
