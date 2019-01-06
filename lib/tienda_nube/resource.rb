module TiendaNube
  module Resource
    AUTHENTICATION_HEADER = 'Authentication'.freeze
    CONTENT_TYPE_HEADER = 'Content-Type'.freeze
    CONTENT_TYPE_JSON = 'application/json'.freeze
    HTTPS = 'https'.freeze
    LINK = 'link'.freeze
    
    def base_url
      "#{@api_url}/#{@api_version}/#{@store_id}"
    end

    def send_request(uri, request)
      request[AUTHENTICATION_HEADER] = "bearer #{@access_token}"
      request[CONTENT_TYPE_HEADER] = CONTENT_TYPE_JSON
      response = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == HTTPS) do |http|
        http.request request
      end

      result = {
        :status => [response.code, response.message],
        :headers => response.to_hash,
        :body => response.body && !response.body.empty? ? 
          JSON.parse(response.body) : nil
      }

      if links = response[LINK]
        result[:pages] = links.split(", ").inject({}) do |hash, link|
          array = link.split("; ")
          hash[$1] = array[0].gsub(/^<(.*)>$/, '\1') if array[1].match(/rel=\"([a-z]+)\"/)
          hash
        end
      end

      result
    end

    def uri(path)
      unless (uri = URI(path)).absolute?
        uri = URI(base_url)
        uri.path = "/#{@api_version}/#{@store_id}/#{path}"
      end

      uri
    end

    def get_request(path, query = {})
      uri = uri(path)
      uri.query = URI.encode_www_form(query) unless query.empty?
      request = Net::HTTP::Get.new uri
      send_request(uri, request)
    end

    def delete_request(path)
      uri = uri(path)
      request = Net::HTTP::Delete.new uri
      send_request(uri, request)
    end

    def post_request(path, data)
      uri = uri(path)
      request = Net::HTTP::Post.new uri
      request.body = data.to_json
      send_request(uri, request)
    end

    def put_request(path, data)
      uri = uri(path)
      request = Net::HTTP::Put.new uri
      request.body = data.to_json
      send_request(uri, request)
    end
  end
end
