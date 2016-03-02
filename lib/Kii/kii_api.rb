module KiiAPI

  @@log = Logger.new STDOUT

  def request action, path, data = nil, headers = {}
    headers.merge!({'x-kii-appid' => @app_id || @config.app_id , 'x-kii-appkey' => @app_key || @config.app_key})
#    headers[:accept] = :json
    headers[:content_type] ||= "application/json"
    # need to find a way to set token depending on centext. eg user access token
    # maybe I'll mix this into user as well. and name the var admin_token
    headers["Authorization"] = "Bearer #{@access_token}" if @access_token
    @@log.debug " action : #{action} \n path : #{path} \n headers : #{headers} \n data : #{data}"
    response = data ? RestClient.send(action, path, data, headers) :
                      RestClient.send(action, path, headers)

    @@log.debug "response : #{response}"
    response
  end
end

