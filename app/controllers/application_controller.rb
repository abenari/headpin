require 'active_resource/exceptions'

class ApplicationController < ActionController::Base
  protect_from_forgery
  layout 'kalpana'
  helper_method :organization
  before_filter :set_gettext_locale, :set_locale

  # This is a fairly giant hack to make the request
  # available to the Models for active record
  before_filter :store_request_in_thread

  # Global error handling, parsed bottom-up so most specific goes at the end:
  rescue_from Exception, :with =>  :handle_generic_error
  rescue_from ActiveResource::ServerError, :with =>  :handle_candlepin_server_error
  rescue_from Errno::ECONNREFUSED, :with => :handle_candlepin_connection_error

  # Generic handler triggered whenever a controller action doesn't explicitly
  # do it's own error handling:
  def handle_generic_error ex
    log_exception(ex)
    errors _("An unexpected error has occurred, details have been logged.")
    redirect_to :back
  end

  # Handle ISE's from Candlepin:
  def handle_candlepin_server_error ex
    log_exception(ex)
    errors _("An error has occurred in the Entitlement Server.")
    redirect_to :back
  end

  # Handle ISE's from Candlepin:
  def handle_candlepin_connection_error ex
    log_exception(ex)
    render :text => _("Unable to connect to the Entitlement Server.")
  end

  # Small helper to keep logging of exceptions consistent:
  def log_exception ex
    logger.error ex
    logger.error ex.class
    logger.error ex.backtrace.join("\n")
  end

  def store_request_in_thread
      Thread.current[:request] = request
  end

  # Override this in subclasses to specify the
  # controller's section_id
  def section_id
    'generic'
  end

  def errors summary, failures = [], successes = []
    flash[:error] ||= {}
    flash[:error][:successes] = successes
    flash[:error][:failures] = failures
    flash[:error][:summary] = summary
  end
  
  def organization
    org_id = session[:current_organization_id]
    @org ||= Organization.find(org_id) unless org_id.nil?
    @org
  end
  
  def logged_in_user
    @user ||= User.find(current_user) unless current_user.nil?
  end

  private

  # TODO:  Refactor these two methods!
  def require_org
    if organization.nil?

      # Assume that non-super-admins have a single org
      # and just set that
      unless logged_in_user.superAdmin?
        @org = Organization.find(logged_in_user.owner.key)
        return true
      end

      # Otherwise redirect the user to pick an org
      flash[:notice] = _('Please select an organization')

      session[:original_uri] = request.fullpath
      redirect_to admin_organizations_url
      return false
    end

    true
  end

  def require_user
    if current_user.nil?
      #user not logged
      flash[:notice] = _("You must be logged in to access that page.")

      #save original uri and redirect to login page
      session[:original_uri] = request.request_uri
      redirect_to new_login_url
      
      return false
    end

    # Set the user so navigation can detect if tabs for admins should be shown:
    logged_in_user

    true
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
    locale = "en_US"
    locale = request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first \
      if not request.env['HTTP_ACCEPT_LANGUAGE'].nil?
    return locale
  end
end
