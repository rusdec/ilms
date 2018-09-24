class PassageDecorator < Draper::Decorator
  include HasStatus

  delegate_all

  decorates_association :user
  decorates_association :passable
  decorates_association :parent
end
