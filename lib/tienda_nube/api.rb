module TiendaNube
    class Api
        class Base
            include TiendaNube::Resource

            PATH_JOIN_CHAR = "/".freeze

            class << self
                attr_accessor :name
            end

            attr_accessor :api_url, :api_version, :store_id, :access_token, :user_agent

            def initialize(store_id, access_token, user_agent = nil)
                @store_id = store_id
                @access_token = access_token
                @api_url = TiendaNube::API_URL
                @api_version = TiendaNube::API_VERSION
                @user_agent = user_agent
            end

            def all(query = {})
              get_request(uri_path, query)
            end

            def get(id)
              get_request(uri_path(id))
            end

            def delete(id)
              delete_request(uri_path(id))
            end

            def create(data)
              post_request(uri_path, data)
            end

            def update(id, data)
              put_request(uri_path(id), data)
            end

            def from_url(url)
              get_request(url)
            end

            def uri_path(id = nil)
                [self.class.name, id].compact.join(PATH_JOIN_CHAR)
            end
        end

        class Store < Api::Base
            undef_method :all, :delete, :create, :update

            def get
              get_request('store'.freeze)
            end
        end
        
        class Product < Api::Base
            self.name = 'products'.freeze
        end
        
        class Category < Api::Base
            self.name = 'categories'.freeze
        end

        class Customer < Api::Base
            self.name = 'customers'.freeze
        end

        class Order < Api::Base
            self.name = 'orders'.freeze
        end

        class ProductBase < Api::Base
            def all(product_id, query = {})
                get_request(uri_path(product_id), query)
              end
  
              def get(product_id, id)
                get_request(uri_path(product_id, id))
              end
  
              def delete(product_id, id)
                delete_request(uri_path(product_id, id))
              end
  
              def create(product_id, data)
                post_request(uri_path(product_id), data)
              end
  
              def update(product_id, id, data)
                put_request(uri_path(product_id, id), data)
              end

            def uri_path(product_id, id = nil)
                ["products", product_id, self.class.name, id].compact.join(PATH_JOIN_CHAR)
            end
        end

        class ProductVariant < Api::ProductBase
            self.name = 'variants'.freeze
        end

        class ProductImage < Api::ProductBase
          self.name = 'images'.freeze
        end

        class Webhook < Api::Base
          self.name = 'webhooks'.freeze
        end
    end
end