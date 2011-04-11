class DashboardController < ApplicationController
  before_filter :require_user
  navigation :dashboard

  def section_id
    'dashboard'
  end

  def index
    # Just a stub for now...  
  end

end
