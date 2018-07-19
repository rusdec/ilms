module ApplicationHelper
  def format_date(date)
    date.strftime('%d.%m.%Y')
  end

  def underscored_klass(object)
    object.class.to_s.underscore
  end

  def yield_if_author(object)
    if can? :author, object
      yield if block_given?
    end
  end

  def page_header(text = '')
    content_tag :div, class: 'page-header' do
      concat(tag.h1 text, class: 'page-title')
    end
  end

  def simple_card(params)
    title = if params[:title].empty?
              ''
            else
              tag.h2 params[:title], class: 'mt-0 mb4'
            end

    body = params[:body]

    wraper = content_tag :div, class: 'text-wrap p-lg-6' do
      concat(title)
      concat(body)
    end

    wraper = content_tag :div, class: 'card-body' do
      concat(wraper)
    end

    content_tag :div, class: 'card' do
      concat(wraper)
    end
  end

  def lesson_sidebar_link(params)
    link_to params[:text], params[:path], class: 'list-group-item list-group-item-action'
  end
end
