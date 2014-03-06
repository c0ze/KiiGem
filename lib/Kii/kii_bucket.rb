require_relative 'kii_api'
require_relative 'kii_object'

class KiiBucket

    include KiiAPI
    include KiiObjectPersistance

  def initialize name, context, path
    @name = name
    @context = context
    @path = path
  end

  def new_object data
    KiiObject.new data, @context, "#{@path}/buckets/#{@name}/objects"
  end

  def get_objects
    headers = {
      content_type: "application/vnd.kii.QueryRequest+json"
    }
    data = {
      bucketQuery: {
        clause: {
          type: :all
        }
      }
    }
    @context.request :post, "#{@path}/buckets/#{@name}/query", data.to_json, headers
  end
end
