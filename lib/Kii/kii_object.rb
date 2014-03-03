module KiiObjectPersistance
  class KiiObject
    attr_accessor :id, :version, :created, :modified, :owner, :data, :type, :app

    def initialize data, app, path
      @app = app
      @data = data
      @path = path
    end

    def init obj
      @created = obj['createdAt'] || obj['_created']
      @id ||= obj['objectID'] || obj['_id']
      @type = obj['dataType'] 
      @version = obj['_version'].to_i || 1
      @owner ||= obj['_owner']
      @modified ||= obj['_modified']
      
      deleted_keys = ['_created', '_id', '_version', '_owner', '_modified', 'objectID', 'createdAt', 'dataType']
      deleted_keys.each{|key| obj.delete key}
      @data = obj
    end

    def to_s
      "id:#{@id}\ncreated:#{@created}\nversion:#{@version}\ntype:#{@type}\ndata:#{@data}"
    end

    def create
      response = @app.request(:post, @path, @data.to_json)
      self.init(JSON.parse response)
      response
    end

    def get
      response = @app.request :get, "#{@path}/#{@id}"
      init JSON.parse response
      response
    end

    def delete
      headers = {"If-Match" => @version}
      response = @app.request :delete, "#{@path}/#{@id}", nil, headers
    end

    def update
      headers = {"If-Match" => @version}
      response = @app.request :put, "#{@path}/#{@id}", @data.to_json, headers
      @version += 1
      response
    end

    # this seems unnecessary ?
    # just make your changes locally and do update ?
    def patch
      headers = {"If-Match" => @version}
      response = @app.request :patch, "#{@path}/#{@id}", @data.to_json, headers
      @version += 1
      response
      #      'X-HTTP-Method-Override' => 'PATCH'
    end
  end

  def new_object data, app, path
    KiiObject.new data, app, path
  end
end
