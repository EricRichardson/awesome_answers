class HomeController < ApplicationController
  def index
  end

  def about
  end

  def greet
    @name = params[:name].capitalize
  end
end
