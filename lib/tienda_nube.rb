require 'net/https'
require 'json'

require "tienda_nube/version"
require 'tienda_nube/resource'
require 'tienda_nube/auth'
require 'tienda_nube/api'
require 'tienda_nube/client'

module TiendaNube
  API_URL = 'https://api.tiendanube.com'.freeze
  API_VERSION = 'v1'.freeze
  LANGUAGE = 'es'.freeze
end
