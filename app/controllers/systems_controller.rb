class SystemsController < ApplicationController

  def show
    @consumer = @cp.get_consumer(params[:id])
    pp @consumer
  end

  def section_id
    'systems'
  end
end

