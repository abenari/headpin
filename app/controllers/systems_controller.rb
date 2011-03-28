require 'candlepin_api'

class SystemsController < ApplicationController

  def section_id
    'systems'
  end

  def index
    @consumers = @cp.list_consumers
  end

  def show
    @consumer = @cp.get_consumer(params[:id])
    @owner = @cp.get_owner @consumer['owner']['href']
  end

  def subscriptions
    @consumer = @cp.get_consumer(params[:id])

    # Method currently used for both GET and POST, check if we're subscribing:
    if params.has_key?("pool_id")
      pool_id = params['pool_id']
      Rails.logger.info "#{@consumer['uuid']} binding to pool #{pool_id}"
      ent = @cp.consume_pool(pool_id, {:uuid => @consumer['uuid']})[0]
      product_name = @cp.get_pool(ent['pool']['id'])['productName']
      flash[:notice] = _("Subscribed to #{product_name}.")
    end

    @entitlements = @cp.list_entitlements({:uuid => params[:id]})
  end

  def available_subscriptions
    @consumer = @cp.get_consumer(params[:id])
    @pools = @cp.list_pools({:consumer => params[:id]})
    @entitlements = @cp.list_entitlements({:uuid => params[:id]})
  end

  def unbind
    ent_id = params['entitlement_id']
    ent = @cp.get_entitlement(ent_id)
    @consumer = @cp.get_consumer(params[:id])
    Rails.logger.info "#{@consumer['uuid']} unbinding entitlement #{ent_id}"
    @cp.unbind_entitlement(ent_id, {:uuid => @consumer['uuid']})
    product_name = @cp.get_pool(ent['pool']['id'])['productName']
    flash[:notice] = _("Unsubscribed from #{product_name}.")
    redirect_to subscriptions_system_path(params['id'])
  end


end

