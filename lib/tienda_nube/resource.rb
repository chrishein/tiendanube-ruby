module TiendaNube
  module Resource
    class << self
      attr_accessor :api_url, :api_version, :store_id, :access_token
    end
    self.api_url = 'https://api.tiendanube.com'
    self.api_version = 'v1'
    def self.config
      yield self
    end
    def self.base_url
      "#{self.api_url}/#{self.api_version}/#{self.store_id}"
    end
    def self.send_request(uri, request)
      request['Authentication'] = "bearer #{self.access_token}"
      request['Content-Type'] = "application/json"
      response = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
        http.request request
      end
      result = {
        :status => [response.code, response.message],
        :headers => response.to_hash,
        :body => response.body && !response.body.empty? ? 
          JSON.parse(response.body) : nil
      }
      if links = response["link"]
        result[:pages] = links.split(", ").inject({}) do |hash, link|
          array = link.split("; ")
          hash[$1] = array[0].gsub(/^<(.*)>$/, '\1') if array[1].match(/rel=\"([a-z]+)\"/)
          hash
        end
      end
      return result
    end
    def self.uri(path)
      unless (uri=URI(path)).absolute?
        uri = URI(self.base_url)
        uri.path = "/#{self.api_version}/#{self.store_id}/#{path}"
      end
      return uri
    end
    def self.get(path, query={})
      uri = self.uri(path)
      uri.query = URI.encode_www_form(query) unless query.empty?
      request = Net::HTTP::Get.new uri
      self.send_request(uri, request)
    end
    def self.delete(path)
      uri = self.uri(path)
      request = Net::HTTP::Delete.new uri
      self.send_request(uri, request)
    end
    def self.post(path, data)
      uri = self.uri(path)
      request = Net::HTTP::Post.new uri
      request.body = data.to_json
      self.send_request(uri, request)
    end
    def self.put(path, data)
      uri = self.uri(path)
      request = Net::HTTP::Put.new uri
      request.body = data.to_json
      self.send_request(uri, request)
    end
    class Base
      class << self
        attr_accessor :name
      end
      def self.all(query={})
        Resource.get(self.name, query)
      end
      def self.get(id)
        Resource.get("#{self.name}/#{id}")
      end
      def self.delete(id)
        Resource.delete("#{self.name}/#{id}")
      end
      def self.create(data)
        Resource.post(self.name, data)
      end
      def self.update(id, data)
        Resource.put("#{self.name}/#{id}", data)
      end
      def self.from_url(url)
        Resource.get(url)
      end
      # class BaseDependant < Base
      #   def self.url(product_id, id=nil)
      # end
    end
  end
  class Store
    def self.get
      Resource.get('store')
    end
  end
  class Product < Resource::Base
    self.name = 'products'
  end
  class Category < Resource::Base
    self.name = 'categories'
  end
  class ProductVariant < Resource::Base
    class << self
      attr_accessor :product_id

      def name
        "products/#{self.product_id}/variants"
      end
    end
    def self.url(id = nil)
      url = "#{Resource.base_url}/products/#{self.product_id}/#{self.name}"
      url = "#{url}/#{id}" if id
      return url
    end
  end
end
