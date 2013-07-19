# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include ExceptionNotifiable

  before_filter   :authenticate,
                  :set_locale

  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password

  def set_locale
    # if params[:locale] is nil then I18n.default_locale will be used
    I18n.locale = params[:locale]
  end

  def authenticate
    # default to true
    password_protected = if defined? PASSWORD_PROTECTED
      PASSWORD_PROTECTED
    else
      true
    end

    if password_protected
      authenticate_or_request_with_http_basic do |username, password|
        username == APP_LOGIN and password == APP_PASSWORD
      end
    else
      true
    end
  end

  def default_url_options(options={})
    #logger.debug "default_url_options is passed options: #{options.inspect}\n"
    { :locale => I18n.locale }
  end

  # Provides default sublayouts to application controllers, override if necessary (see ProjectsController)
  def sub_layout
    'empty'
  end
end
