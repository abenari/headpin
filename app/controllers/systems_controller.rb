require 'candlepin_api'

class SystemsController < ApplicationController

  def section_id
    'systems'
  end

  def index
    @systems = System.find(:all)
  end

  def show
    @system = System.find(params[:id])
    # Owner hateoas form is giving us a bad ID (we need key), so splitting the
    # href to get at it.
    @organization = Organization.find(@system.owner.href.split('/')[-1])
  end

  def subscriptions
    @system = System.find(params[:id])

    # Method currently used for both GET and POST, check if we're subscribing:
    if params.has_key?("pool_id")
      pool_id = params['pool_id']
      Rails.logger.info "#{@system.uuid} binding to pool #{pool_id}"
      ent = @system.bind(pool_id)
      product_name = Subscription.find(ent.pool.id).productName
      flash[:notice] = _("Subscribed to #{product_name}.")
    end

    @entitlements = Entitlement.find(:all, :system_id => @system.uuid)
  end

  def available_subscriptions
    @system = System.find(params[:id])
    @subscriptions = Subscription.find(:all, :params => {:consumer => @system.uuid})
  end

  def unbind
    ent_id = params['entitlement_id']
    @system = System.find(params[:id])
    ent = Entitlement.find(ent_id, :system_id => @system.uuid)
    Rails.logger.info "#{@system.uuid} unbinding entitlement #{ent_id}"
    product_name = Subscription.find(ent.pool.id).productName
    ent.destroy
    flash[:notice] = _("Unsubscribed from #{product_name}.")
    redirect_to subscriptions_system_path(params['id'])
  end

  def destroy
    @system = System.find(params[:id])
    candlepin.unregister(params[:id])
    flash[:notice] = _("Deleted system #{@system.name}.")
    redirect_to systems_path
  end

end

