require 'hashie'
module LinkedIn
  module Helpers

    module Request

      API_PATH = '/v1'

      protected

        def get(path, options={})
          response = request(:get, path, options, false, false)
          raise_errors response
          response
        end

        def post(path, body='', options={})
          response = request(:post, path, options, false, false)
          raise_errors response
          response
        end

        def put(path, body, options={})
          response = request(:put, path, options, false, false)
          raise_errors response
          response
        end

        def delete(path, options={})
          response = request(:delete, path, options, false, false)
          raise_errors response
          response
        end

      private

         def request(method, path, options, raw=false, unformatted=false)
          response = connection(raw).send(method) do |request|
            path = formatted_path(path) unless unformatted
            case method
            when :get, :delete
              request.url(path, options)
            when :post, :put
              request.path = path
              request.body = options unless options.empty?
            end
          end
          raw ? response : response.body
        end

        def formatted_path(path)
          path = API_PATH + path
        end

        def raise_errors(response)
          # Even if the json answer contains the HTTP status code, LinkedIn also sets this code
          # in the HTTP answer (thankfully).
          case response["status"].to_i
          when 401
            data = Hashie::Mash.new response
            raise LinkedIn::Errors::UnauthorizedError.new(data), "(#{data.status}): #{data.message}"
          when 400
            data = Hashie::Mash.new response
            raise LinkedIn::Errors::GeneralError.new(data), "(#{data.status}): #{data.message}"
          when 403
            data = Hashie::Mash.new response
            raise LinkedIn::Errors::AccessDeniedError.new(data), "(#{data.status}): #{data.message}"
          when 404
            raise LinkedIn::Errors::NotFoundError, "(#{response['code']}): #{response['message']}"
          when 500
            raise LinkedIn::Errors::InformLinkedInError, "LinkedIn had an internal error. Please let them know in the forum. (#{response['code']}): #{response['message']}"
          when 502..503
            raise LinkedIn::Errors::UnavailableError, "(#{response['code']}): #{response['message']}"
          end
        end

        def to_query(options)
          options.inject([]) do |collection, opt|
            collection << "#{opt[0]}=#{opt[1]}"
            collection
          end * '&'
        end

        def to_uri(path, options)
          uri = URI.parse(path)

          if options && options != {}
            uri.query = to_query(options)
          end
          uri.to_s
        end
    end

  end
end
