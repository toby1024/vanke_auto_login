class WeixinController < ApplicationController
  skip_before_action :verify_authenticity_token
  def index
    user = User.find_by(wxopenid: params[:openid])
    render json: { code: 500 } and return if user.blank?
    render json: { code: 1000, points: UserPoint.where(user: user).order(id: :desc).first(10)
                                           .as_json(only: [:point], methods: [:phone, :format_created_at]) }
  end

  def create
    phone    = params[:phone]
    password = params[:password]
    openid   = params[:openid]
    user     = User.find_by(phone: phone, password: password)
    render json: { code: 500 } and return if user.blank?

    user.update(wxopenid: openid)
    render json: { code: 1000, points: UserPoint.where(user: user).order(id: :desc).first(10)
                                                  .as_json(only: [:point], methods: [:phone, :format_created_at]) }
  end
end
