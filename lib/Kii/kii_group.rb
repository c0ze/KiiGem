
require_relative 'kii_bucket'
require_relative 'kii_object'

module KiiGroupPersistance
  class KiiGroup

    include KiiObjectPersistance

    attr_accessor :name, :id, :owner, :members

    def initialize args, context, path
      args.each do |k,v|
        instance_variable_set("@#{k}", v) unless v.nil?
      end
      @context = context
      @path = path
    end


    def info
      @context.request :get, "#{@path}/#{@id}"
    end

    def create
      headers = {
        :accept       => "application/vnd.kii.GroupCreationResponse+json",
        :content_type => "application/vnd.kii.GroupCreationRequest+json"
      }
      data = {
        name: @name,
        owner: @owner,
        members: @members
      }
      response = @context.request :post, @path, data.to_json, headers
      @id = (JSON.parse response)['groupID'] #todo : check not found users
      response
    end

    def delete 
      @context.request :delete, "#{@path}/#{@id}"
    end

    def buckets bucket_name
      KiiBucket.new(bucket_name, @context, "#{@path}/#{@id}")
    end

    def new_object data, bucket = "groupdata"
      buckets(bucket).new_object data
    end

  end

  def new_group args, context, path
    KiiGroup.new args, context, path
  end

end
