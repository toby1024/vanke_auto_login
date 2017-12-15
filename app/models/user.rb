class User < ApplicationRecord
  require "net/https"
  require "uri"
  require 'json'
  require "base64"

  # 数据唯一性保证
  validates :phone, uniqueness: { case_sensitive: false, message: "手机号码已经存在", on: :create }

  enum status: { active: 1, archived: 2 }


  class << self

    def auto_check
      logger.info("-----start eheck user-------")
      User.active.each do |user|
        next if user.end_time >= Time.current
        user.archived!
        logger.info "user: #{user.phone} is time over!"
      end
      logger.info("-----start eheck user-------")
    end

    def auto_login
      logger.info '--------start auto login----------'
      User.active.each do |user|
        next if user.password.blank?

        phone    = Base64.strict_encode64(user.phone)
        password = Base64.strict_encode64(user.password)

        response_data = login(phone, password)
        if response_data["state"]["errCode"] == 10000
          access_token  = response_data["body"]["access_token"]
          refresh_token = response_data["body"]["refresh_token"]
          get_point(access_token, refresh_token, user)
        end
      end
      logger.info '--------auto login over----------'
    end

    def login(phone, password)
      uri = URI.parse("https://union.vanke.com/api/Member/Login")
      Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
        request      = Net::HTTP::Post.new(uri, 'Content-Type' => 'application/json')
        request.body = { body:   { AccountName:      phone,
                                   AgentId:          "",
                                   AuthCode:         "",
                                   LoginType:        1,
                                   Password:         password,
                                   ThirdPartyUserId: "", Token: ""
        },
                         header: { version:      "",
                                   clientOSType: "android",
                                   accessToken:  "",
                                   refreshToken: "",
                                   sign:         ""
                         }
        }.to_json
        response     = http.request(request)
        JSON.parse(response.body)
      end
    end

    def get_point(access_token, refresh_token, user)
      # get my points
      get_point_url = URI.parse("https://union.vanke.com/api/Points/GetMyPoints")

      Net::HTTP.start(get_point_url.host, get_point_url.port, use_ssl: true) do |http|
        request       = Net::HTTP::Post.new(get_point_url, 'Content-Type' => 'application/json')
        request.body  = { body:   user.vk_id,
                          header: { version:      "",
                                    clientOSType: "android",
                                    accessToken:  access_token,
                                    refreshToken: refresh_token,
                                    sign:         "" }
        }.to_json
        response      = http.request(request)
        response_data = JSON.parse(response.body)
        point         = response_data["body"]
        UserPoint.create(user: user, point: point, status: 1)
      end
    end
  end

  def vanke_login?(plant_password)
    uri      = URI.parse("https://union.vanke.com/api/Member/Login")
    phone    = Base64.strict_encode64(self.phone)
    password = Base64.strict_encode64(plant_password)

    response_data = User.login(phone, password)

    if response_data["state"]["errCode"] == 10000
      vk_id = response_data["body"]["AgentInfo"]["Id"]
      update(password: plant_password, vk_id: vk_id)
      access_token  = response_data["body"]["access_token"]
      refresh_token = response_data["body"]["refresh_token"]
      User.get_point(access_token, refresh_token, self)
    else
      false
    end
  end

  def last_point
    UserPoint.where(user: self).order(id: :desc).first
  end
end