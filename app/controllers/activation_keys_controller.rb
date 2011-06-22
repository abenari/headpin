class ActivationKeysController < ApplicationController
  include AutoCompleteSearch
  respond_to :html, :js
    
  navigation :systems
  before_filter :require_user
  before_filter :require_org
  before_filter :find_activation_key, :only => [:edit, :update, :destroy] 
    
  def section_id
    'activation_keys'
  end

  def new
    render :partial=>"new"
  end
  
  def index
    @activation_keys = ActivationKey.find_by_org(working_org.key)
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
  
  def create
    begin
      @activation_key = ActivationKey.new(:name => params[:name])
      @activation_key.owner= working_org
      @activation_key.save!
    rescue Exception => error
      errors error.to_s
      Rails.logger.info error.backtrace.join("\n")
      render :text=> error.to_s, :status=>:bad_request and return
    end
    render :partial=>"common/list_item", :locals=>{:item=>@activation_key, :accessor=>"id", :columns=>['name', 'poolCount']}
  end  
  
  def destroy
    begin
      @activation_key.destroy
      flash[:notice] = N_("Activation Key '#{@activation_key.name}' was deleted.")
      redirect_to :action => 'index'
    rescue ActiveResource::ForbiddenAccess => error
      errors error.message
      render :show
    end
  end    

  def find_activation_key
    @activation_key = ActivationKey.find(params[:id])
    @organization = Organization.find @activation_key.owner.key
  end
end
