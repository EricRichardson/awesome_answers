class Api::BaseController < ApplicationController
  protect_from_forgery with: :null_session
  

  def authenticate_api_user
    @user = User.find_by_api_key params[:api_key]
    head :forbidden unless @user
  end

end
