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
    @entitlements = @cp.list_entitlements({:uuid => params[:id]})
  end

end

