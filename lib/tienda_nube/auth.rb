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
    USER_AGENT_HEADER = 'User-Agent'.freeze
    HTTPS = 'https'.freeze
    
    def initialize(client_id, client_secret, user_agent = nil, country = :ar)
      @client_id = client_id
      @client_secret = client_secret
      @user_agent = user_agent
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
      request = Net::HTTP::Post.new uri
      request.set_form_data(params)

      request[USER_AGENT_HEADER] = @user_agent unless @user_agent.nil?
      response = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == HTTPS) do |http|
        http.request request
      end

      if response.code != HTTP_CODE_200
        return { :error => SERVER_ERROR_MESSAGE }
      else
        json = JSON.parse(response.body)
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
