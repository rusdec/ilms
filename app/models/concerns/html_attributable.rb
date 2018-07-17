module HtmlAttributable
  extend ActiveSupport::Concern

  class_methods do
    def html_attributes(*args)
      args.each do |attribute|
        define_method "#{attribute}_html" do
          self[attribute] ? self[attribute].html_safe : ''
        end
      end
    end
  end
end
