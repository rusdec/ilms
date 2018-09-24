module HasImage
  extend ActiveSupport::Concern

  included do
    def image_original(params = {})
      return if object.image.file.nil?
      h.image_tag object.image.url, params
    end

    def image_preview(params = {})
      return if object.image.file.nil?
      h.image_tag object.image.preview.url, params
    end
  end
end
