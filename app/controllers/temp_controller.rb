class TempController < ApplicationController
  def index
  end

  def create
    @temp = params[:temperature]
    @fahrenheit = (@temp.to_f * 1.8 + 32)
    @error = "Please enter a number" unless @temp.to_i.to_s == @temp
    render :index
  end
end
