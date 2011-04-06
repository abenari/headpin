class ApplicationController < ActionController::Base
  protect_from_forgery
  layout 'kalpana'
  helper_method :current_organization

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

  def current_user
    env['warden'].user
  end
end
