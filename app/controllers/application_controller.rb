class ApplicationController < ActionController::Base
  protect_from_forgery
  layout 'kalpana'
  helper_method :current_organization

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
end
