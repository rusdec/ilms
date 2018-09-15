require "application_responder"

class ApplicationController < ActionController::Base
  before_action :set_locale
  before_action :set_gon_i18n
  before_action :set_gon_locale

  self.responder = ApplicationResponder
  respond_to :html

  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json do
        render json: { status: false, errors: [exception.message] }
      end

      format.html do
        redirect_to root_path(locale: I18n.locale), { alert: t('access_denied') }
      end
    end
  end

  def self.default_url_options(options = {})
    options.merge(locale: I18n.locale)
  end

  protected

  def after_sign_in_path_for(resource)
    user_path(resource)
  end

  def after_sign_out_path_for(resource)
    new_user_session_path
  end

  def after_sign_up_path_for(resource)
    user_path(resource)
  end

  def set_gon_i18n
    gon.i18n = YAML.load_file('config/locales/frontend/i18n.yml').to_json()
  end

  def set_gon_locale
    gon.locale = I18n.locale
  end

  def set_locale
    I18n.locale = I18n.locale_available?(params[:locale]) ? params[:locale] : I18n.default_locale
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up,
      keys: [:name, :surname, :email, :password, :password_confirmation]
    )
  end
end
