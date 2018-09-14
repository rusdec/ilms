require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Ilms
  class Application < Rails::Application
    # Use the responders controller from the responders gem
    config.app_generators.scaffold_controller :responders_controller
    config.action_controller.default_url_options = {}

    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    Dir[Rails.root.join('app/libs/**/*.rb')].each { |f| require f }

    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', 'backend', '**', '*.{rb,yml}')]
    config.i18n.default_locale = :ru
  end
end
