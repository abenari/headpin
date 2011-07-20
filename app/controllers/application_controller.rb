#
# Copyright 2011 Red Hat, Inc.
#
# This software is licensed to you under the GNU General Public
# License as published by the Free Software Foundation; either version
# 2 of the License (GPLv2) or (at your option) any later version.
# There is NO WARRANTY for this software, express or implied,
# including the implied warranties of MERCHANTABILITY,
# NON-INFRINGEMENT, or FITNESS FOR A PARTICULAR PURPOSE. You should
# have received a copy of GPLv2 along with this software; if not, see
# http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt.

require 'active_resource/exceptions'

class ApplicationController < ActionController::Base
  protect_from_forgery
  layout 'katello'
  helper_method :working_org
  before_filter :set_gettext_locale, :set_locale
  #before_filter :set_visible_orgs

  # This is a fairly giant hack to make the request
  # available to the Models for active record
  before_filter :store_request_in_thread

  # Global error handling, parsed bottom-up so most specific goes at the end:
  #rescue_from Exception, :with =>  :handle_generic_error
  rescue_from ActiveResource::ServerError, :with =>  :handle_candlepin_server_error
  rescue_from Errno::ECONNREFUSED, :with => :handle_candlepin_connection_error

  # Generic handler triggered whenever a controller action doesn't explicitly
  # do it's own error handling:
  def handle_generic_error ex
    log_exception(ex)
    errors _("An unexpected error has occurred, details have been logged.")
    redirect_back
  end

  # Handle ISE's from Candlepin:
  def handle_candlepin_server_error ex
    log_exception(ex)
    errors _("An error has occurred in the Entitlement Server.")
    redirect_back
  end

  # Handle ISE's from Candlepin:
  def handle_candlepin_connection_error ex
    log_exception(ex)
    render :text => _("Unable to connect to the Entitlement Server.")
  end

  def redirect_back
    begin
      redirect_to :back
    rescue ActionController::RedirectBackError
      render :text => _("Error has occurred, unable to redirect to previous page.")
    end
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
  
  def working_org
    org_id = session[:current_organization_id]
    @working_org ||= Organization.find(org_id) unless org_id.nil?
    @working_org
  end

  def working_org=(org)
    @working_org = org
    session[:current_organization_id] = org.key
  end
  
  def logged_in_user
    @user ||= current_user
  end

  private

  # Sets a variable listing all orgs the current user can access. We can safely
  # assume that there is a logged in user at this point.
  def set_visible_orgs
    @visible_orgs ||= Organization.find_by_user(logged_in_user.username)
  end

  # TODO:  Refactor these two methods!
  def require_org
    # If no working org is set, just use the first one in the visible list.
    # For non-admins this will be their one and only org.
    if working_org.nil?
      self.working_org = @visible_orgs[0]
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

    # Set the list of visible orgs for this user:
    set_visible_orgs()

    true
  end

  def require_admin
    unless logged_in_user.superAdmin?
      flash[:notice] = _("You must be an administrator to access that page.")
      redirect_to dashboard_index_url
      return false
    end

    true
  end

  def require_no_user
    if current_user
      flash[:notice] = _("Welcome Back!") + ", " + current_user.username
      redirect_to dashboard_index_url
      return false
    end
  end

  def set_locale
    I18n.locale = extract_locale_from_accept_language_header
  end
  
  rescue_from RestClient::Exception do | e |
    j = ActiveSupport::JSON
    data = j.decode(e.response())
    flash[:error] = data["displayMessage"] 
    redirect_back
  end
  
  # XXX like in katello, this is temporary. we need a more robust method,
  # such rack middleware or a rails plugin
  def extract_locale_from_accept_language_header
    locale = "en_US"
    locale = request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first \
      if not request.env['HTTP_ACCEPT_LANGUAGE'].nil?
    return locale
  end
end
