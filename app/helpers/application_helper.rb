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
end
