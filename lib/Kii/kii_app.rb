require 'rest-client'
require 'json'
require 'yaml'
require 'logger'
require 'pry'

require_relative 'constants'
require_relative 'kii_object'
require_relative 'kii_config'
require_relative 'kii_user'
require_relative 'kii_api'
require_relative 'kii_bucket'

class KiiApp

  attr_accessor :access_token, :paths, :log, :config

  include KiiObjectPersistance
  include KiiUserPersistance
  include KiiAPI

  def initialize
    @config = KiiConfig.new

    @@log = @config.debug ? Logger.new(STDOUT) : Logger.new('/dev/null')

    @paths = {
      token:    "#{@config.backend}/oauth2/token",
      app:      "#{@config.backend}/apps/#{@config.app_id}",
      user:     "#{@config.backend}/apps/#{@config.app_id}/users"
    }
  end

  def get_admin_token
    @@log.debug "#{__method__}: #{@config.app_id} #{@config.app_key} #{@config.client_id} #{@config.client_secret}"

    d = {
      'client_id' => @config.client_id,
      'client_secret' => @config.client_secret
    }.to_json
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
