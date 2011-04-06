class ApplicationController < ActionController::Base
  protect_from_forgery
  layout 'kalpana'
  helper_method :current_organization
  before_filter :set_gettext_locale, :set_locale

  # This is a fairly giant hack to make the request
  # available to the Models for active record
  before_filter :store_request_in_thread

  def store_request_in_thread
      Thread.current[:request] = request
  end

  def errors summary, failures = [], successes = []
    flash[:error] ||= {}
    flash[:error][:successes] = successes
    flash[:error][:failures] = failures
    flash[:error][:summary] = summary
  end
  
  def current_organization
    if session.has_key? :current_organization_id
      @current_org =  Organziation.new candlepin.get_owner(session[:current_organization_id])
    end

    @current_org
  end
  
  def current_organization=(org)
    session[:current_organization_id] = org.try(:key)
  end

  def user
    @user ||= User.find(current_user) unless current_user.nil?
  end

  private

  def require_user
    if current_user
      #user logged in

      #redirect to originally requested page
      if session[:original_uri] != nil
        redirect_to session[:original_uri]
        session[:original_uri] = nil  
      end

      return true
    else
      #user not logged
      flash[:notice] = _("You must be logged in to access that page.")

      #save original uri and redirect to login page
      session[:original_uri] = request.request_uri
      redirect_to new_login_url and return false
    end
  end

  def require_no_user
    if current_user
      flash[:notice] = _("Welcome Back!") + ", " + current_user
      redirect_to dashboard_index_url
      return false
    end
  end

  def set_locale
    I18n.locale = extract_locale_from_accept_language_header
  end
  
  # XXX like in kalpana, this is temporary. we need a more robust method,
  # such rack middleware or a rails plugin
  def extract_locale_from_accept_language_header
    request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first
  end
end
