module TiendaNube
    class Api
        class Client
            def initialize(store_id, access_token)
                @store_id = store_id
                @access_token = access_token
                @api_url = TiendaNube::API_URL
                @api_version = TiendaNube::API_VERSION
            end

            def store
                @store ||= Store.new(@store_id, @access_token)
            end

            def product
                @product ||= Product.new(@store_id, @access_token)
            end

            def category
                @category ||= Category.new(@store_id, @access_token)
            end

            def customer
                @customer ||= Customer.new(@store_id, @access_token)
            end

            def order
                @order ||= Order.new(@store_id, @access_token)
            end

            def product_image
                @product_image ||= ProductImage.new(@store_id, @access_token)
            end

            def product_variamt
                @product_variant ||= ProductVariant.new(@store_id, @access_token)
            end
        end
    end
end