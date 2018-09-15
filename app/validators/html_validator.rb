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
      record.errors.add(attribute, :too_short, count: options[:length][:minimum])
    end
  end

  def validate_length_maximum(record, attribute, value)
    return unless options[:length].key?(:maximum) || options[:length][:maximum]

    if text_from(value).length > options[:length][:maximum]
      record.errors.add(attribute, :too_long, count: options[:length][:maximum])
    end
  end

  def validate_presence(record, attribute, value)
    if options.key?(:presence) && blank?(value)
      record.errors.add(attribute, :blank)
    end
  end

  def blank?(value)
    value.blank? || text_from(value).blank?
  end

  def text_from(value)
    Nokogiri::HTML(value).search('//text()').map(&:text).join
  end
end
