module HasTextPreview
  extend ActiveSupport::Concern

  class_methods do
    def text_preview(*args)
      args.each do |attribute|
        define_method "#{attribute}_preview" do
          self[attribute]&.truncate(30)
        end
      end
    end
  end
end
