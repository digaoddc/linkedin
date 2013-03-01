require 'faraday'

module LinkedinFaradayMiddleware
	class RaiseHttpException < Faraday::Middleware
		def call(env)
			@app.call(env).on_complete do |response|
				case response[:status].to_i
				when 400
					raise LinkedIn::Errors::BadRequestError, error_message_400(response)
				end
			end
		end

		def initialize(app)
			super app
		end

		private
		def error_message_400 response
			"#{response[:status]} #{error_body(response[:body])}"
		end

		def error_body body
			return "" if body.blank?
			body = ::JSON.parse(body)
			"#{body['error']} - #{body['error_description']}"
		end
	end	
end