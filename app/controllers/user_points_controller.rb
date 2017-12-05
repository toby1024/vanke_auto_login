class UserPointsController < ApplicationController
  def index
    user_id = session[:user_id]
    redirect_to "/" if user_id.nil?

    @user_points = UserPoint.where("user_id = ?", user_id).order(id: :desc).first(50)
  end
end
