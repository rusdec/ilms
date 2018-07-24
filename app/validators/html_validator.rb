class HtmlValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    validate_presence(record, attribute, value)
    validate_length(record, attribute, value)
  end

  private

  def validate_length(record, attribute, value)
    return unless options.key?(:length) || options[:length]

    validate_length_minimum(record, attribute, value)
    validate_length_maximum(record, attribute, value)
  end

  def validate_length_minimum(record, attribute, value)
    return unless options[:length].key?(:minimum) || options[:length][:minimum]

    if text_from(value).length < options[:length][:minimum]
      message = "is too short (minimum is #{options[:length][:minimum]} characters)"
      record.errors.add(attribute, message)
    end
  end

  def validate_length_maximum(record, attribute, value)
    return unless options[:length].key?(:maximum) || options[:length][:maximum]

    if text_from(value).length > options[:length][:maximum]
      message = "is too long (maximum is #{options[:length][:maximum]} characters)"
      record.errors.add(attribute, message)
    end
  end

  def validate_presence(record, attribute, value)
    if options.key?(:presence) && blank?(value)
      record.errors.add(attribute, 'can\'t be blank')
    end
  end

  def blank?(value)
    value.blank? || text_from(value).blank?
  end

  def text_from(value)
    Nokogiri::HTML(value).search('//text()').map(&:text).join
  end
end
