require_relative 'kii_api'
require_relative 'kii_object'

module KiiUserPersistance
  class KiiUser

    include KiiAPI
    include KiiObjectPersistance

    attr_accessor :login_name, :display_name, :country, :password, :email, :phone_number, :id, :access_token

    def initialize args, app, path
      args.each do |k,v|
        instance_variable_set("@#{k}", v) unless v.nil?
      end
      @app = app
      @path = path
    end


    def signup is_minimum = false
      response = @app.request :post, @path, (object is_minimum).to_json 
      @id = (JSON.parse response)['userID']
      response
    end

    def info
      @app.request :get, "#{@path}/#{@id}"
    end


    def delete 
      @app.request :delete, "#{@path}/#{@id}"
    end

    def resend_email_verification
      @app.request :post, "#{@path}/#{@id}/email-address/resend-verification"
    end

    def resend_sms_verification
      @app.request :post, "#{@path}/#{@id}/phone-number/resend-verification"
    end

    def get_token
      d = {username: @login_name, password: @password}
      response = @app.request :post, token_path, d.to_json
      @access_token = (JSON.parse response)['access_token']
      response
    end

    def new_object data
      KiiObject.new data, @app, @path
    end

    def object minimum = false
      h = {
        loginName: @login_name, 
        displayName: @display_name, 
        country: @country, 
        password: @password
      }
      h.merge!({ 
        emailAddress: @email, 
        phoneNumber: @phone_number
      }) unless minimum
      h
    end

  end

  def new_user args, app, path
    KiiUser.new args, app, path
  end

end
