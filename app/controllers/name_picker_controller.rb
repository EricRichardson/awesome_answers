class NamePickerController < ApplicationController
  def index
  end

  def pick
    names = params[:names].split(',')
    @winner = names[rand(names.length)].capitalize
    render :index
  end
end
