class SystemsController < ApplicationController

  def index
    @consumers = @cp.list_consumers
  end

  def show
    @consumer = @cp.get_consumer(params[:id])
    pp @consumer
    @owner = @cp.get_owner @consumer['owner']['href']
  end

  def section_id
    'systems'
  end
end

