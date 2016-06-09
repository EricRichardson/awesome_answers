class NamePickerController < ApplicationController
  def index
  end

  def pick
    names = params[:names].split(',')
    @winner = names[rand(names.length)]
    render :index
  end
end
