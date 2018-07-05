module ApplicationHelper
  def format_date(date)
    date.strftime('%d.%m.%Y')
  end

  def underscored_klass(object)
    object.class.to_s.underscore
  end
end
