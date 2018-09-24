module Passaged
  extend ActiveSupport::Concern

  included do
    include Polymorphed
    include JsonResponsed

    before_action :authenticate_user!, only: %i(learn! passages)

    def learn!
      passable = polymorphic_resource_class.find(params[:id])
      authorize! :publicated, passable

      json_response_by_result(
        { with_location: :passage_path,
          without_object: true,
          with_flash: true },
        passage_class.create(user: current_user, passable: passable)
      )
    end

    protected

    def passage_class
      "#{polymorphic_resource_class}Passage".constantize
    end
  end
end
