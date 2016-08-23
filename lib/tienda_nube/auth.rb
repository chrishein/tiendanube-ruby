module TiendaNube
  class Auth
    class << self
      attr_accessor :client_id, :client_secret
    end
    Auth_URL = { :ar => "https://www.tiendanube.com/apps",
      :br => "https://www.nuvemshop.com.br/apps"}
    def self.config
      yield self
    end
    def initialize(country = :ar)
      @client_id = Auth.client_id
      @client_secret = Auth.client_secret
      @country = country
    end
    def authorize_url
      [Auth_URL[@country], @client_id, "authorize"].join("/")  
    end
    def get_access_token(code)
      params = {
        :client_id => @client_id,
        :client_secret => @client_secret,
        :grant_type => 'authorization_code',
        :code => code
      }
      uri = URI([Auth_URL[@country], 'authorize/token'].join('/'))
      request = Net::HTTP.post_form(uri ,params)
      if request.code != "200"
        return {:error => "server error"}
      else
        json = JSON.parse(request.body)
        if json["error_description"]
          {:error => json["error_description"]}
        else
          { :store_id => json["user_id"],
            :access_token => json["access_token"],
            :scope => json["scope"] }
        end
      end
    end
  end
end
