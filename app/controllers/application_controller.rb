class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :set_locale

  rescue_from StandardError, with: :standard_error
  rescue_from Mongoid::Errors::DocumentNotFound, with: :not_found

  def standard_error(e)
    respond_to do |format|
      format.html { raise e }
      format.json { render json: {"error": ["Internal error"]}, status: 500 }
    end
  end

  def not_found(e)
    respond_to do |format|
      format.html { raise e }
      format.json { render json: {"error": ["Not found"]}, status: :not_found }
    end
  end

  def set_locale
    logger.debug "* Accept-Language: #{request.env['HTTP_ACCEPT_LANGUAGE']}"
    I18n.locale = extract_locale_from_accept_language_header
    logger.debug "* Locale set to '#{I18n.locale}'"
  end

  private
    def extract_locale_from_accept_language_header
      if request.env['HTTP_ACCEPT_LANGUAGE']
        user_locale = request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first
        if ['en', 'de'].include?(user_locale)
          return user_locale
        end
      end
      logger.debug "* Locale '#{I18n.locale}' not set, using 'en'"
      'en'
    end
end
