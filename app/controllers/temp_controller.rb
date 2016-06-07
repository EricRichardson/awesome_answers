class TempController < ApplicationController
  def index
  end

  def create
    @fahrenheit = (params[:temperature].to_f * 1.8 + 32)
    render :index
  end
end
