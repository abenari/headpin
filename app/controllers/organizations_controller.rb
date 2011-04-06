require 'pp'
require 'candlepin_api'

class OrganizationsController < ApplicationController
  navigation :organizations

  def section_id
    'orgs'
  end

  def index
    @organizations = Organization.find(:all)
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
#    begin
      @organization = Organization.find(params[:id])
      @organization.update_attributes(params[:organization])

#      if @organization.invalid?
#        render :edit
#        return
#      end

      #@organization.save()

      # TODO:  This conversion should be done on the model!
#      org = {:key => params[:organization][:key],
#        :displayName => params[:organization][:name]}
#      @cp.update_owner(@organization.key, org)

      flash[:notice] = N_("Organization '#{@organization.displayName}' was updated.")
      redirect_to :action => 'index' and return
#    rescue Exception => error
#      Rails.logger.error error
#      errors error.to_s
#      redirect_to :action => 'show', :id => params[:id]
#    end
  end

  def destroy
    @organization = Organization.find(params[:id])
    begin
      candlepin.delete_owner(params[:id])
      flash[:notice] = N_("Organization '#{params[:id]}' was deleted.")
    rescue Exception => error
      errors error.to_s
      redirect_to :action => 'show', :id => params[:id] and return
    end
    redirect_to :action => 'index'
  end  

  # Based on the Kalpana code in providers controller:
  def subscriptions
    @organization = Organization.find(params[:id])

    # Check if this request is a manifest upload:
    if params.has_key? :contents
      Rails.logger.info "Uploading a subscription manifest."
      temp_file = nil
      begin
        temp_file = File.new(File.join("#{Rails.root}/tmp", "import_#{SecureRandom.hex(10)}.zip"), 'w+', 0600)
        temp_file.write params[:contents].read
        temp_file.close
        candlepin.import(@organization.key, File.expand_path(temp_file.path))
        #notice _("Subscription uploaded successfully")
      rescue Exception => error
        #notice _("There was a format error with your Subscription Manifest")
        Rails.logger.error "error uploading subscriptions."
        Rails.logger.error error
      end
    end

    @subscriptions = [{'productName' => _("None Imported"), "consumed" => "0", "quantity" => "0"}]
    begin
      @subscriptions = candlepin.list_pools({:owner => @organization.id})
    rescue Exception => error
      Rails.logger.error "Error fetching subscriptions from Candlepin"
      Rails.logger.error error
    end
  end

end
