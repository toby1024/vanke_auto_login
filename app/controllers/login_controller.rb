class LoginController < ApplicationController
  def index
    @user = User.new
  end

  def create
    phone = params[:phone]
    password = params[:password]
    user = User.find_by(phone: phone)

    if user.nil?
      flash[:login_error] = "没有登记的用户，请联系3-1801！"
      redirect_to "/" and return
    end
    
    unless user.vanke_login?(password)
      flash[:login_error] = "万科系统登录失败，请到万科app中确认你的密码！"
      redirect_to "/" and return
    end

    session[:user_id] = user.id
    
    redirect_to "/user_points" 
  end
end
