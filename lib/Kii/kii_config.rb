require 'dotenv'
Dotenv.load

class KiiConfig

  attr_accessor :app_id, :app_key, :client_id, :client_secret, :app_name, :mail_address, :description, :country, :backend, :debug

  def backends
    {
      us: "https://api.kii.com/api",
      jp: "https://api-jp.kii.com/api"
    }
  end

  def initialize
    @app_id = ENV['APP_ID']
    @app_key = ENV['APP_KEY']
    @client_id = ENV['CLIENT_ID']
    @client_secret = ENV['CLIENT_SECRET']
    @app_name = ENV['APP_NAME']
    @mail_address = ENV['MAIL_ADDRESS']
    @description = ENV['DESCRIPTION']
    @country = ENV['COUNTRY']
    @debug = ENV['DEBUG']

    @backend = backends[@country.downcase.to_sym]
    raise "Unknown API Backend" unless @backend
  end
end
