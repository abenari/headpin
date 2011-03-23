class ApplicationController < ActionController::Base
  protect_from_forgery
  layout 'kalpana'

  def errors summary, failures = [], successes = []
    flash[:error] ||= {}
    flash[:error][:successes] = successes
    flash[:error][:failures] = failures
    flash[:error][:summary] = summary
  end

end
