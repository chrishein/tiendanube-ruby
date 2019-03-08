module TiendaNube
    class Api
        class Client
            def initialize(store_id, access_token, user_agent = nil)
                @store_id = store_id
                @access_token = access_token
                @api_url = TiendaNube::API_URL
                @api_version = TiendaNube::API_VERSION
                @user_agent = user_agent
            end

            def store
                @store ||= Store.new(@store_id, @access_token, @user_agent)
            end

            def product
                @product ||= Product.new(@store_id, @access_token, @user_agent)
            end

            def category
                @category ||= Category.new(@store_id, @access_token, @user_agent)
            end

            def customer
                @customer ||= Customer.new(@store_id, @access_token, @user_agent)
            end

            def order
                @order ||= Order.new(@store_id, @access_token, @user_agent)
            end

            def product_image
                @product_image ||= ProductImage.new(@store_id, @access_token, @user_agent)
            end

            def product_variant
                @product_variant ||= ProductVariant.new(@store_id, @access_token, @user_agent)
            end
        end
    end
end