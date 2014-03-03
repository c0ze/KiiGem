require 'rest-client'
require 'json'
require 'yaml'
require 'logger'
require 'pry'

require_relative 'constants'
require_relative 'kii_object'
require_relative 'kii_user'
require_relative 'kii_api'

class KiiApp

  attr_accessor :access_token, :app_admin_token, :app_id, :app_key, :client_id, :client_secret, :app_name, :mail_address, :description, :debug, :log

  include KiiObjectPersistance
  include KiiUserPersistance
  include KiiAPI
  

  @@conf_keys = ['app_id', 'app_key', 'client_id', 'client_secret']

  def initialize
    configure
    @log = Logger.new STDOUT
  end

  def configure
    config = YAML.load_file './config/kii.yml'
    @@conf_keys.each { |key|
      if config[key].nil? || config[key] == '' then
        puts "config error. Please set #{key} in config/kii.yml"
        exit 2
      end
      instance_variable_set("@#{key}", config[key]) unless config[key].nil?
    }
  end

  def get_admin_token
    @log.debug "#{__method__}: #{@app_id} #{@app_key} #{@client_id} #{@client_secret}"

    d = {'client_id' => @client_id, 'client_secret' => @client_secret}.to_json
    response = request :post, token_path, d

    @app_admin_token = (JSON.parse response)['access_token']
    response
  end

  def new_object data
    super data, self, app_data_path
  end

  def new_user args
    super args, self, user_path
  end

end
