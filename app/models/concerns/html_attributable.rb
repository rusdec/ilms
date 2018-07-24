module HtmlAttributable
  extend ActiveSupport::Concern

  class_methods do
    def html_attributes(*args)
      args.each do |attribute|
        define_method "#{attribute}_html" do
          self[attribute] ? self[attribute].html_safe : ''
        end
        define_method "#{attribute}_html_empty?" do
          return true unless self[attribute]

          self[attribute].blank? || Nokogiri::HTML(self[attribute]).
                                      search('//text()').
                                      map(&:text).
                                      join.
                                      blank?
        end
        define_method "#{attribute}_html_text" do
          Nokogiri::HTML(self[attribute]).search('//text()').map(&:text)
        end
      end
    end
  end
end
