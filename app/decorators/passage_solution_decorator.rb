class PassageSolutionDecorator < Draper::Decorator
  include DateDecorator

  delegate_all
  decorates_association :status
  decorates_association :passage
end
