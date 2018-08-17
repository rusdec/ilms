module Imaged
  extend ActiveSupport::Concern

  included do
    include Polymorphic

    protected

    def ready_to_imaged?
      params[:image]
    end

    def delete_image
      polymorphic_resource.image.purge
    end

    def attache_image
      return unless ready_to_imaged?
      polymorphic_resource.image.attach(params[:image])
    end

    def update_image
      return unless ready_to_imaged?
      delete_image
      attache_image
    end
  end
end
