require 'rest-client'
require 'json'
require 'yaml'
require 'logger'
require 'pry'

require_relative 'constants'
require_relative 'kii_object'
require_relative 'kii_user'
require_relative 'kii_api'
require_relative 'kii_bucket'

class KiiApp

  attr_accessor :access_token, :paths, :app_id, :app_key, :client_id, :client_secret, :app_name, :mail_address, :description, :debug, :log

  include KiiObjectPersistance
  include KiiUserPersistance
  include KiiAPI


  @@conf_keys = ['app_id', 'app_key', 'client_id', 'client_secret', 'country']


  def initialize
    configure
    @@log = Logger.new STDOUT
    @paths = {
      token:    "#{@@api_backend}/oauth2/token",
      app:      "#{@@api_backend}/apps/#{@app_id}",
      user:     "#{@@api_backend}/apps/#{@app_id}/users"
    }
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
    set_api_backend
  end

  def set_api_backend
    case @country
    when 'us'
      @@api_backend = KII_US
    when 'jp'
      @@api_backend = KII_JP
    else
      raise "Unknown API Backend"
    end
  end

  def get_admin_token
    @@log.debug "#{__method__}: #{@app_id} #{@app_key} #{@client_id} #{@client_secret}"

    d = {'client_id' => @client_id, 'client_secret' => @client_secret}.to_json
    response = request :post, @paths[:token], d

    @access_token = (JSON.parse response)['access_token']
    response
  end

  def buckets bucket_name
    KiiBucket.new(bucket_name, self, "#{@paths[:app]}")
  end

  def new_object data, bucket = "applicationMaster"
    buckets(bucket).new_object data
  end


  def new_user args
    super args, self, @paths[:user]
  end

end
