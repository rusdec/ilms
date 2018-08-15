class PassageDecorator < Draper::Decorator
  delegate_all

  decorates_association :user
  decorates_association :status
  decorates_association :passable
  decorates_association :parent
end
