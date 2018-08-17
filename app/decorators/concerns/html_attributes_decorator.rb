# Create few methods
#
# ===== Examples
#
# html_attributes :body
#
# def body_html ... end         => <p>Body</p>
# def body_as_text ... end      => Body
# def body_html_empty? ... end  => true if <p></p>
#                                  false if <p>Body</p>
module HtmlAttributesDecorator
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
        define_method "#{attribute}_as_text" do
          Nokogiri::HTML(self[attribute]).search('//text()').map(&:text).join
        end
      end
    end
  end
end
