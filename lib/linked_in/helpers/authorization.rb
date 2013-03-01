module LinkedIn
  module Helpers

    module Authorization
      AUTH_URL         = "https://www.linkedin.com/uas/oauth2/authorization"
      ACCESS_TOKEN_URL = "https://www.linkedin.com"

     def authorize_url(options={})
        uri_with_params({
          :base          => AUTH_URL,
          :response_type => "code",
          :client_id     => client_id,
          :state         => SecureRandom.hex(15),
          :redirect_uri  => redirect_uri,
          :scope         => "rw_nus"
        }.merge!(options))
     end

     def new_access_token code
        options = {
          #:headers => {'Accept' => "application/#{format}; charset=utf-8", 'User-Agent' => user_agent},
          :ssl => {:verify => true},
          :url => ACCESS_TOKEN_URL,
        }
        con = Faraday::Connection.new(options) do |connection|
            connection.use Faraday::Request::UrlEncoded
            connection.use Faraday::Response::ParseJson
            connection.use Faraday::Adapter::NetHttp
            connection.use LinkedinFaradayMiddleware::RaiseHttpException
        end
        response = con.post "/uas/oauth2/accessToken",
          {
            :grant_type    => "authorization_code",
            :code          => code,
            :redirect_uri  => redirect_uri,
            :client_id     => client_id,
            :client_secret => client_secret
          }
        response.body
     end

      private

        def uri_with_params args
          url = "#{args.delete(:base)}?"
          args.each do |k,v|
              url += "&#{k}=#{v}"
          end
          url
        end

        # since LinkedIn uses api.linkedin.com for request and access token exchanges,
        # but www.linkedin.com for authorize/authenticate, we have to take care
        # of the url creation ourselves.
        # def parse_oauth_options
        #   {
        #     :request_token_url => full_oauth_url_for(:request_token, :api_host),
        #     :access_token_url  => full_oauth_url_for(:access_token,  :api_host),
        #     :authorize_url     => full_oauth_url_for(:authorize,     :auth_host),
        #     :site              => @consumer_options[:site] || @consumer_options[:api_host] || DEFAULT_OAUTH_OPTIONS[:api_host]
        #   }
        # end

        # def full_oauth_url_for(url_type, host_type)
        #   if @consumer_options["#{url_type}_url".to_sym]
        #     @consumer_options["#{url_type}_url".to_sym]
        #   else
        #     host = @consumer_options[:site] || @consumer_options[host_type] || DEFAULT_OAUTH_OPTIONS[host_type]
        #     path = @consumer_options[:"#{url_type}_path".to_sym] || DEFAULT_OAUTH_OPTIONS["#{url_type}_path".to_sym]
        #     "#{host}#{path}"
        #   end
        # end

    end

  end
end
