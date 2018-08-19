module Imaged
  extend ActiveSupport::Concern

  included do
    include Polymorphed

    protected

    def ready_to_imaged?
      image_params[:image]
    end

    def delete_image
      polymorphic_resource.image.purge
    end

    def attache_image
      return unless ready_to_imaged?
      polymorphic_resource.image.attach(image_params[:image])
    end

    def update_image
      return unless ready_to_imaged?
      delete_image
      attache_image
    end

    def image_params
      params.require(:badge).permit(:image)
    end
  end
end
