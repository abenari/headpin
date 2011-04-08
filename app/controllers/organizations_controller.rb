require 'pp'

class OrganizationsController < ApplicationController
  navigation :organizations
  before_filter :require_user

  def section_id
    'orgs'
  end

  def index
    @organizations = user.superAdmin? ? Organization.find(:all) : [Organization.find(user.owner.key)]
  end

  def show
    @organization = Organization.find(params[:id])
  end

  def use
    @organization = Organization.find(params[:id])
    current_organization = @organization
    flash[:notice] = N_("Now using organization '#{@organization.displayName}'.")
    redirect_to organization_path(@organization.key)
  end

  def new
    @organization = Organization.new
    @organization.displayName = nil
    @organization.key = nil
  end

  def create
    begin
      @organization = Organization.new(params[:organization])
      @organization.save

      flash[:notice] = N_("Organization '#{@organization.displayName}' was created.")
    rescue Exception => error
      errors error.to_s
      Rails.logger.info error.backtrace.join("\n")
      redirect_to :action => 'new' and return
    end
    redirect_to :action => 'show', :id => @organization.key
  end

  def edit
    @organization = Organization.find(params[:id])
  end

  def systems
    @organization = Organization.find(params[:id])
    @systems = System.find(:all, :params => { :owner => @organization.key })
    Rails.logger.debug("Found #{@systems.size} consumers for owner: #{@organization.key}")
  end

  def update
    @organization = Organization.find(params[:id])
    @organization.update_attributes(params[:organization])

    if @organization.save
      flash[:notice] = N_("Organization '#{@organization.displayName}' was updated.")
      redirect_to :action => 'index'
    else
      errors N_('There were errors updating the organization:'), @organization.errors.full_messages
      render :edit
    end
  end

  def destroy
    @organization = Organization.find(params[:id])

    begin
      @organization.destroy
      flash[:notice] = N_("Organization '#{@organization.displayName}' was deleted.")
      redirect_to :action => 'index'
    rescue ActiveResource::ForbiddenAccess => error
      errors error.message
      render :show
    end
  end  

  # Based on the Kalpana code in providers controller:
  def subscriptions
    @organization = Organization.find(params[:id])

    # Check if this request is a manifest upload:
    if params.has_key? :contents
      Rails.logger.info "Uploading a subscription manifest."
      temp_file = nil
      temp_file = File.new(File.join("#{Rails.root}/tmp", "import_#{SecureRandom.hex(10)}.zip"), 'w+', 0600)
      temp_file.write params[:contents].read
      temp_file.close
      @organization.import(File.expand_path(temp_file.path))
    end

    @subscriptions = [{'productName' => _("None Imported"), "consumed" => "0", "quantity" => "0"}]
    begin
      # Going to attributes here as we've overloaded key as id in the model:
      @subscriptions = Subscription.find(:all, :params => { :owner => @organization.attributes['id']})
    rescue Exception => error
      Rails.logger.error "Error fetching subscriptions from Candlepin"
      Rails.logger.error error
    end
  end

end
