module KiiAPI
  def token_path
    "#{API_END_POINT}/oauth2/token"
  end

  def app_data_path
    "#{API_END_POINT}/apps/#{@app_id}/buckets/applicationMaster/objects"
  end

  def user_path
    "#{API_END_POINT}/apps/#{@app_id}/users"
  end

  def request action, path, data = nil, headers = {}
    headers.merge!({'x-kii-appid' => @app_id, 'x-kii-appkey' => @app_key})
#    headers[:accept] = :json
    headers[:content_type] ||= :json
    # need to find a way to set token depending on centext. eg user access token
    # maybe I'll mix this into user as well. and name the var admin_token
    headers["Authorization"] = "Bearer #{@app_admin_token}" if @app_admin_token
    @log.debug " action : #{action} \n path : #{path} \n headers : #{headers} \n data : #{data}" 
    response = data ? RestClient.send(action, path, data, headers) :
                      RestClient.send(action, path, headers)

    @log.debug "response : #{response}"
    response
  end
end

