class DashboardController < ApplicationController
  before_filter :require_user
  navigation :dashboard

  before_filter :require_org
  
  def section_id
    'dashboard'
  end

  def index
    @org = working_org  
  end

end
