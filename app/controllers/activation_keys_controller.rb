class ActivationKeysController < ApplicationController
  include AutoCompleteSearch

  respond_to :html, :js
  
    
  navigation :systems
  before_filter :require_user
  before_filter :require_org

  def section_id
    'activation_keys'
  end

  def index
    @activation_keys = ActivationKey.find_for_org(working_org.key)
  end
  

end
