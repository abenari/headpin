
class SystemsController < ApplicationController

  respond_to :html, :js
  
  before_filter :require_user 
  before_filter :require_org
  before_filter :find_system, :only => [:edit, :facts, :subscriptions, 
    :available_subscriptions, :unbind, :destroy, :update,
    :events]

  def section_id
    'systems'
  end

  def index
    @systems = System.find(:all, :params => {:owner => working_org.key, 
      :type => :system})
  end
  
  def edit
    render :partial => 'edit'
  end 
  
  def facts
    render :partial => 'edit_facts'
  end  
  
  def events
    @events = Event.find_for_consumer(@system.uuid)
    render :partial => 'edit_events'
  end

  def subscriptions

    # Method currently used for both GET and POST, check if we're subscribing:
    if params.has_key?("pool_id")
      pool_id = params['pool_id']
      Rails.logger.info "#{@system.uuid} binding to pool #{pool_id}"
      ent = @system.bind(pool_id)
      product_name = Subscription.find(ent.pool.id).productName
      flash[:notice] = _("Subscribed to #{product_name}.")
    end

    @entitlements = Entitlement.find(:all, :params => {:consumer => @system.uuid})
    
    render :partial => "subscriptions"
  end

  def available_subscriptions
    @subscriptions = Subscription.find(:all, :params => {:consumer => @system.uuid})
    render :partial => "available_subscriptions"    
  end

  def unbind
    ent_id = params['entitlement_id']
    ent = Entitlement.find(ent_id, :system_id => @system.uuid)
    Rails.logger.info "#{@system.uuid} unbinding entitlement #{ent_id}"
    product_name = Subscription.find(ent.pool.id).productName
    ent.destroy
    flash[:notice] = _("Unsubscribed from #{product_name}.")
    redirect_to subscriptions_system_path(params['id'])
  end

  def destroy
    @system.destroy
    flash[:notice] = _("Deleted system #{@system.name}.")
    redirect_to systems_path
  end
  
  def update
    @system.update_attributes(params[:system])

    @system.save!

    respond_to do |format|
      format.html {render :text => params[:system].values.first}
      format.js
    end
  end  
  
  def find_system
    @system = System.find(params[:id])
    @organization = Organization.find @system.owner.key
  end

end

