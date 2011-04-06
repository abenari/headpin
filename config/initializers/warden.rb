
Rails.configuration.middleware.use RailsWarden::Manager do |manager|
  manager.default_strategies :candlepin
  manager.failure_app = LoginController
end

# Setup Session Serialization
class Warden::SessionSerializer
  def serialize(username)
    username 
  end

  def deserialize(username)
    username
  end
end

Warden::Strategies.add(:candlepin) do

  def valid?
    params[:username] && params[:password]
  end

  def authenticate!
    username = params[:username]

    http = Net::HTTP.new(AppConfig.candlepin.host, AppConfig.candlepin.port)
    req = Net::HTTP::Get.new("#{AppConfig.candlepin.prefix}/users/#{username}")
    http.use_ssl = true
    req.basic_auth username, params[:password]
    response = http.request(req)

    if response.code == '200'
      success! username
    else
      fail!("Username or password is not correct")
    end

  end
end
