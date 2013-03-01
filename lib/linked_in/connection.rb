require File.expand_path('../faraday/oauth2.rb', __FILE__)
require File.expand_path('../faraday/raise_http_exception.rb', __FILE__)

module LinkedIn
	module Connection
		private

		def connection(raw=false)
			options = {
				:headers => {'Accept' => "application/#{format}; charset=utf-8", 'User-Agent' => user_agent,'x-li-format' => "json"},
				:ssl => {:verify => false},
				:url => endpoint,
			}
			Faraday::Connection.new(options) do |connection|
				connection.use LinkedinFaradayMiddleware::OAuth2, client_id, access_token
				connection.use Faraday::Request::UrlEncoded
				unless raw
					connection.use Faraday::Response::ParseJson
					#connection.use FaradayMiddleware::Mashify
				end
				connection.adapter(adapter)
			end
		end
	end	
end
