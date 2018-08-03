module Passaged
  extend ActiveSupport::Concern

  include Polymorphed
  include JsonResponsed

  def passage
    passable = polymorphic_resource_class.find(params[:id])
    json_response_by_result(
      { with_location: :passage_path,
        without_object: true,
        with_flash: true },
      passable.passages.create(user_id: current_user.id)
    )
  end
end
