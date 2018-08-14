class UserDecorator < Draper::Decorator
  delegate_all

  def full_name
    "#{name} #{surname}"
  end
end
