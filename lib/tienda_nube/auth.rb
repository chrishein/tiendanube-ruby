module TiendaNube
  class Auth
    AUTH_URL = {  :ar => "https://www.tiendanube.com/apps",
                  :br => "https://www.nuvemshop.com.br/apps"
    }.freeze
    AUTHORIZE_PATH = "authorize".freeze
    AUTHORIZE_TOKEN_PATH = "authorize/token".freeze
    PATH_JOIN_CHAR = "/".freeze
    AUTHORIZATION_CODE_GRANT_TYPE = "authorization_code".freeze
    HTTP_CODE_200 = "200".freeze
    USER_ID = "user_id".freeze
    ACCESS_TOKEN = "access_token".freeze
    SCOPE = "scope".freeze
    SERVER_ERROR_MESSAGE = "server error".freeze
    ERROR_DESCRIPTION = "error_description".freeze

    class << self
      attr_accessor :client_id, :client_secret
    end

    def self.config
      yield self
    end

    def initialize(country = :ar)
      @client_id = Auth.client_id
      @client_secret = Auth.client_secret
      @country = country
    end

    def authorize_url
      [AUTH_URL[@country], @client_id, AUTHORIZE_PATH].join(PATH_JOIN_CHAR)  
    end

    def get_access_token(code)
      params = {
        :client_id => @client_id,
        :client_secret => @client_secret,
        :grant_type => AUTHORIZATION_CODE_GRANT_TYPE,
        :code => code
      }

      uri = URI([AUTH_URL[@country], AUTHORIZE_TOKEN_PATH].join(PATH_JOIN_CHAR))
      request = Net::HTTP.post_form(uri ,params)

      if request.code != HTTP_CODE_200
        return { :error => SERVER_ERROR_MESSAGE }
      else
        json = JSON.parse(request.body)
        if json[ERROR_DESCRIPTION]
          { :error => json[ERROR_DESCRIPTION] }
        else
          { :store_id => json[USER_ID],
            :access_token => json[ACCESS_TOKEN],
            :scope => json[SCOPE]
          }
        end
      end
    end
  end
end
