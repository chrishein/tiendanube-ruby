require 'net/https'
require 'json'

require "tienda_nube/version"
require 'tienda_nube/resource'
require 'tienda_nube/auth'

module TiendaNube
  API_URL = 'https://api.tiendanube.com'
  API_Version = 'v1'
  class << self
    attr_accessor :access_token, :client_id, :client_secret, :store_id, :language
  end
  self.language = 'es'
end
