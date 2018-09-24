class Ilms::AdministratorGenerator < Rails::Generators::Base
  desc 'This generator creates administrator'

  class_option :email, type: :string, required: true
  class_option :name, type: :string, default: 'Name' 
  class_option :surname, type: :string, default: 'Surname'
  class_option :password, type: :string, required: true

  def create_adinistration
    administrator = Administrator.new(
      email: options[:email],
      name: options[:name],
      surname: options[:surname],
      password: options[:password]
    )

    administrator.valid? ? administrator.save! : print_errors(administrator)
    say_status 'ok', 'administrator was created', :green if administrator.persisted?
  end

  protected

  def print_errors(administrator)
    administrator.errors.full_messages.each do |message|
      say_status 'error', message, :red
    end
  end
end
