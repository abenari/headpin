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
      Rails.logger.info "#{@consumer['uuid']} subscribing to pool #{pool_id}"
      @cp.consume_pool(pool_id, {:uuid => @consumer['uuid']})
    end

    @entitlements = @cp.list_entitlements({:uuid => params[:id]})
  end

  def available_subscriptions
    @consumer = @cp.get_consumer(params[:id])
    @pools = @cp.list_pools({:consumer => params[:id]})
    @entitlements = @cp.list_entitlements({:uuid => params[:id]})
  end


end

