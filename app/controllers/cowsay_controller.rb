class CowsayController < ApplicationController
  def index
  end

  def create
    @cowsay = Cowsay.say params[:sentence]
  end
end
