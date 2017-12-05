class UsersController < ApplicationController
  def index
    secret = params[:secret]
    redirect_to "/" if secret.blank?
    redirect_to "/" if secret != Figaro.env.create_secret

    @users = User.order(id: :desc)
  end

  def new
    @user = User.new
  end

  def create
    phone = params[:user][:phone]
    password = params[:user][:password]

    if password != Figaro.env.create_secret
      flash[:message] = "非法登记！"
      redirect_to "/users/new" and return
    end

    user = User.new(phone: phone, status: 1, start_time: Time.current, end_time: Time.current + 1.year)
    if user.save
      flash[:message] = "登记成功！"
    else
      flash[:message] = "登记失败！#{user.errors.messages}"
    end
    
    redirect_to "/users/new"
  end
end
