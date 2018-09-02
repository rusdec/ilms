module ApplicationHelper
  def format_date(date)
    date.strftime('%d.%m.%Y')
  end

  def underscored_klass(object)
    object.class.to_s.underscore
  end

  def yield_if_author(object)
    object = object.object if object&.decorated?
    if can? :author, object
      yield if block_given?
    end
  end

  def page_header(text = '')
    content_tag :div, class: 'page-header' do
      concat(tag.h1 text, class: 'page-title')
    end
  end

  def page_header_3(text = '')
    tag.h5 text, class: 'text-gray'
  end

  def material_card(material)
    return if material.body_html_empty?

    unless material.summary_html_empty?
      material.body += "#{tag.h4 'Summary'}#{material.summary}"
    end

    simple_card(title: material.title,
                body: material.body_html,
                anchor: "material-#{material.id}")
  end

  def simple_card(params)
    wraper = content_tag :div, class: 'text-wrap p-lg-3' do
      concat(params[:title].empty? ? '' : tag.h4(params[:title], class: 'mt-0 mb4'))
      concat(params[:body])
    end

    wraper = content_tag :div, class: "card-body" do
      concat(wraper)
    end

    content_tag :div, class: 'card', id: "#{params[:anchor]}" do
      concat(wraper)
    end
  end

  def lesson_sidebar_link(params)
    tag.span href: params[:path], class: 'list-group-item list-group-item-action' do
      params[:text]
    end
  end

  def progress_color(value)
    case value.to_i
    when 25..49 then 'bg-orange'
    when 50..74 then 'bg-yellow'
    when 75..100 then 'bg-green'
    else 'bg-red'
    end
  end
end
