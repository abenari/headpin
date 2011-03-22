require 'pp'
require 'candlepin_api'

class OrganizationsController < ApplicationController
  #navigation :organizations

  def initialize
    @cp = OauthCandlepinApi.new('admin', 'kalpana', 'shhhh')
    super
  end

  def section_id
    'orgs'
  end

  def index
    @organizations = @cp.list_owners()
  end

  def show
    @organization = @cp.get_owner(params[:id])

    # TODO: example of RBAC protection (will turn this into Rails filters soon)
    #deny_access unless current_user.allowed_to? 'show', 'organization', "org_name:#{@organization.name}"
  end

  def new
    # TODO: example of RBAC protection (will turn this into Rails filters soon)
    #deny_access unless current_user.allowed_to?({:controller => "organizations", :action => "new"})
  end

  def create
    begin
      @organization = @cp.create_owner params[:name]

#      @organization = Kalpana::Glue::Organization.create! params
#      @organization = {
#        :name => params[:name], 
#        :description => params[:description]}
#      Candlepin::Owner.create @organization
      flash[:notice] = N_("Organization '#{@organization["displayName"]}' was created.")
      # TODO: example - create permission for the organization
      #current_user.role.first.allow 'show', 'organization', "org_name:#{@organization.name}"
    rescue Exception => error
      errors error.to_s
      Rails.logger.info error.backtrace.join("\n")
      redirect_to :action => 'new' and return
    end
    redirect_to :action => 'show', :id => @organization["displayName"]
  end

  def edit
    @organization = Kalpana::Glue::Organization.first :name => params[:id]
    @env_choices =  @organization.environments.collect {|p| [ p.name, p.name ]}
  end

  def update
    begin
      @organization = Kalpana::Glue::Organization.update(params[:id], params[:kalpana_model_organization])
      flash[:notice] = N_("Organization '#{@organization["name"]}' was updated.")
      redirect_to :action => 'index' and return
    rescue Exception => error
      errors error.to_s
      redirect_to :action => 'show', :id => params[:id]      
    end
  end

  def destroy
    begin
      Kalpana::Glue::Organization.destroy params[:id]
      flash[:notice] = N_("Organization '#{params[:id]}' was deleted.")
    rescue Exception => error
      errors error.to_s
      redirect_to :action => 'show', :id => params[:id] and return
    end
    redirect_to :action => 'index'
  end  

  # Based on the Kalpana code in providers controller:
  def subscriptions
    @organization = @cp.get_owner params[:id]
#    if !params[:kalpana_model_provider].blank? and params[:kalpana_model_provider].has_key? :contents
#      temp_file = nil
#      begin
#        temp_file = File.new(File.join("#{Rails.root}/tmp", "import_#{SecureRandom.hex(10)}.zip"), 'w+', 0600)
#        temp_file.write params[:kalpana_model_provider][:contents].read
#        temp_file.close
#        Kalpana::Glue::Provider.import_manifest params[:id], File.expand_path(temp_file.path)
#        notice _("Subscription uploaded successfully")
#      rescue Exception => error
#        notice _("There was a format error with your Subscription Manifest")
#        Rails.logger.error "error uploading subscriptions."
#        Rails.logger.error error
#      end
#    end

#    @providers = Kalpana::Model::Provider.find(:all)
#    @provider = Kalpana::Model::Provider.find(params[:id])
    # We default to none imported until we can properly poll Candlepin for status of the import
    @subscriptions = [{'productName' => _("None Imported"), "consumed" => "0", "quantity" => "0"}]
    begin
      # Use current owner?
      @subscriptions = Candlepin::Owner.pools @organization['key']
    rescue Exception => error
      Rails.logger.error "Error fetching subscriptions from Candlepin"
      Rails.logger.error error
    end
  end
  
end
