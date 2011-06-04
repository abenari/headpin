class ActivationKeysController < ApplicationController
  include AutoCompleteSearch

  respond_to :html, :js
  
    
  navigation :systems
  before_filter :require_user
  before_filter :require_org
  before_filter :find_activation_key, :only => [:edit, :update] 
    
  def section_id
    'activation_keys'
  end

  def index
    @activation_keys = ActivationKey.find_for_org(working_org.key)
  end
  
  def edit
    puts @activation_key.to_json()    
    render :partial => 'edit'
  end   
  
  def update
    @activation_key.update_attributes(params[:activation_key])
    puts @activation_key.to_json()
    @activation_key.save!

    respond_to do |format|
      format.html {render :text => params[:activation_key].values.first}
      format.js
    end
  end    

  def find_activation_key
    @activation_key = ActivationKey.find(params[:id])
    @organization = Organization.find @activation_key.owner.key
  end
end
