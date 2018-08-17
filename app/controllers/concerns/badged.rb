module Badged
  extend ActiveSupport::Concern

  included do
    include Polymorphed

    before_action :set_badgable, only: %i(add_badge)
    before_action :set_badge, only: %i(add_badge)

    def add_badge
      @badgable.badges << @badge
    end

    protected

    def set_badgable
      @badgable = polymorphic_resource_class.find(params[:id])
    end

    def set_badge
      @badge = current_user.created_badges.find(badge_params[:id])
    end

    def badge_params
      params.require(:badge).permit(:id)
    end
  end
end
