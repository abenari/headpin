require 'pp'
require 'candlepin_api'

class OrganizationsController < ApplicationController
  navigation :organizations

  def section_id
    'orgs'
  end

  def index
    # TODO: use model
    @organizations = @cp.list_owners()
  end

  def show
    @organization = Organization.new @cp.get_owner(params[:id])

    # TODO: example of RBAC protection (will turn this into Rails filters soon)
    #deny_access unless current_user.allowed_to? 'show', 'organization', "org_name:#{@organization.name}"
  end

  def use
    @organization = Organization.new @cp.get_owner(params[:id])
    current_organization = @organization
    flash[:notice] = N_("Now using organization '#{@organization.name}'.")
    redirect_to organization_path(@organization.key)
  end

  def new
    # TODO: example of RBAC protection (will turn this into Rails filters soon)
    #deny_access unless current_user.allowed_to?({:controller => "organizations", :action => "new"})
  end

  def create
    begin
      @organization = Organization.new @cp.create_owner(params[:key], 
        {:name => params[:name]})

#      @organization = Kalpana::Glue::Organization.create! params
#      @organization = {
#        :name => params[:name], 
#        :description => params[:description]}
#      Candlepin::Owner.create @organization
      flash[:notice] = N_("Organization '#{@organization.name}' was created.")
      # TODO: example - create permission for the organization
      #current_user.role.first.allow 'show', 'organization', "org_name:#{@organization.name}"
    rescue Exception => error
      errors error.to_s
      Rails.logger.info error.backtrace.join("\n")
      redirect_to :action => 'new' and return
    end
    redirect_to :action => 'show', :id => @organization.key
  end

  def edit
    @organization = Organization.new @cp.get_owner(params[:id])
  end

  def systems
    @organization = Organization.new @cp.get_owner(params[:id])
    @consumers = @cp.list_owner_consumers(params[:id])
    Rails.logger.debug("Found #{@consumers.size} consumers for owner: #{@organization.key}")
  end

  def update
    begin
      @organization = Organization.new @cp.get_owner(params[:id])

      # TODO:  This conversion should be done on the model!
      org = {:key => params[:organization][:key], 
        :displayName => params[:organization][:name]}
      @cp.update_owner(@organization.key, org)

      flash[:notice] = N_("Organization '#{params[:organization][:name]}' was updated.")
      redirect_to :action => 'index' and return
    rescue Exception => error
      errors error.to_s
      redirect_to :action => 'show', :id => params[:id]
    end
  end

  def destroy
    begin
      @cp.delete_owner(params[:id])
      flash[:notice] = N_("Organization '#{params[:id]}' was deleted.")
    rescue Exception => error
      errors error.to_s
      redirect_to :action => 'show', :id => params[:id] and return
    end
    redirect_to :action => 'index'
  end  

  # Based on the Kalpana code in providers controller:
  def subscriptions
    @organization = Organization.new @cp.get_owner params[:id]
#    if !params[:kalpana_model_provider].blank? and params[:kalpana_model_provider].has_key? :contents
    if params.has_key? :contents
      Rails.logger.info "Uploading a subscription manifest."
      temp_file = nil
      begin
        temp_file = File.new(File.join("#{Rails.root}/tmp", "import_#{SecureRandom.hex(10)}.zip"), 'w+', 0600)
        temp_file.write params[:contents].read
        temp_file.close
        @cp.import(@organization.key, File.expand_path(temp_file.path))
        #notice _("Subscription uploaded successfully")
      rescue Exception => error
        #notice _("There was a format error with your Subscription Manifest")
        Rails.logger.error "error uploading subscriptions."
        Rails.logger.error error
      end
    end

#    @providers = Kalpana::Model::Provider.find(:all)
#    @provider = Kalpana::Model::Provider.find(params[:id])
    # We default to none imported until we can properly poll Candlepin for status of the import
    @subscriptions = [{'productName' => _("None Imported"), "consumed" => "0", "quantity" => "0"}]
    begin
      @subscriptions = @cp.list_pools({:owner => @organization.id})
    rescue Exception => error
      Rails.logger.error "Error fetching subscriptions from Candlepin"
      Rails.logger.error error
    end
  end

end
