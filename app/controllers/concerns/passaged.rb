module Passaged
  extend ActiveSupport::Concern


  included do
    include Polymorphed
    include JsonResponsed

    before_action :authenticate_user!, only: %i(learn! passages)

    def learn!
      passable = polymorphic_resource_class.find(params[:id])
      json_response_by_result(
        { with_location: :passage_path,
          without_object: true,
          with_flash: true },
        passable.passages.create(user_id: current_user.id)
      )
    end

    def passages
      @passages = current_user.passages.send "for_#{polymorphic_resource_name.pluralize}"
      render "#{polymorphic_resource_name.pluralize}/passages/index"
    end
  end
end
