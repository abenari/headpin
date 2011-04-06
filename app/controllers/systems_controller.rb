require 'candlepin_api'

class SystemsController < ApplicationController

  def section_id
    'systems'
  end

  def index
    @consumers = candlepin.list_consumers
  end

  def show
    @consumer = candlepin.get_consumer(params[:id])
    @organization = Organization.new candlepin.get_owner @consumer['owner']['href']
  end

  def subscriptions
    @consumer = candlepin.get_consumer(params[:id])

    # Method currently used for both GET and POST, check if we're subscribing:
    if params.has_key?("pool_id")
      pool_id = params['pool_id']
      Rails.logger.info "#{@consumer['uuid']} binding to pool #{pool_id}"
      ent = @cp.consume_pool(pool_id, {:uuid => @consumer['uuid']})[0]
      product_name = @cp.get_pool(ent['pool']['id'])['productName']
      flash[:notice] = _("Subscribed to #{product_name}.")
    end

    @entitlements = candlepin.list_entitlements({:uuid => params[:id]})
  end

  def available_subscriptions
    @consumer = candlepin.get_consumer(params[:id])
    @pools = candlepin.list_pools({:consumer => params[:id]})
    @entitlements = candlepin.list_entitlements({:uuid => params[:id]})
  end

  def unbind
    ent_id = params['entitlement_id']
    ent = candlepin.get_entitlement(ent_id)
    @consumer = candlepin.get_consumer(params[:id])
    Rails.logger.info "#{@consumer['uuid']} unbinding entitlement #{ent_id}"
    candlepin.unbind_entitlement(ent_id, {:uuid => @consumer['uuid']})
    product_name = candlepin.get_pool(ent['pool']['id'])['productName']
    flash[:notice] = _("Unsubscribed from #{product_name}.")
    redirect_to subscriptions_system_path(params['id'])
  end

  def destroy
    @consumer = candlepin.get_consumer(params[:id])
    candlepin.unregister(params[:id])
    flash[:notice] = _("Deleted system #{@consumer['name']}.")
    redirect_to systems_path
  end

end

