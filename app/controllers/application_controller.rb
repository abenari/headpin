class ApplicationController < ActionController::Base
  protect_from_forgery
  layout 'kalpana'
  helper_method :current_organization

  def initialize
    @cp = OauthCandlepinApi.new('admin', 'admin', 'kalpana', 'shhhh')
    super
  end

  def errors summary, failures = [], successes = []
    flash[:error] ||= {}
    flash[:error][:successes] = successes
    flash[:error][:failures] = failures
    flash[:error][:summary] = summary
  end

  
  def current_organization
    if session.has_key? :current_organization_id
      @current_org =  Organziation.new @cp.get_owner(session[:current_organization_id])
    else
      # Temp hack until we have auth, and users logging in:
      @current_org = Organization.new @cp.get_owner('admin')
    end
    return @current_org
  end
  
  def current_organization=(org)
    session[:current_organization_id] = org.try(:key)
  end

end
