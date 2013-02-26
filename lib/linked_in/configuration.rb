module LinkedIn
	module Configuration

		VALID_OPTIONS_KEYS = [
		  :adapter,
	      :client_id,
	      :client_secret,
	      :access_token,
	      :endpoint,
	      :format,
	      :user_agent,
	      :proxy,
	      :token, 
	      :secret, 
	      :default_profile_fields
	    ].freeze


	    # The endpoint that will be used to connect if none is set
	    #
	    # @note There is no reason to use any other endpoint at this time
		DEFAULT_ENDPOINT = 'https://api.linkedin.com'

	    # The response format appended to the path and sent in the 'Accept' header if none is set
	    #
	    # @note JSON is the only available format at this time
		DEFAULT_FORMAT = :json

		# By default, don't set a user access token
		DEFAULT_ACCESS_TOKEN = nil

	    # The adapter that will be used to connect if none is set
	    #
	    # @note The default faraday adapter is Net::HTTP.
	    DEFAULT_ADAPTER = Faraday.default_adapter

	    # The user agent that will be sent to the API endpoint if none is set
	    DEFAULT_USER_AGENT = "LinkedIn Ruby Gem #{LinkedIn::VERSION::STRING}".freeze

	    #The default profile field to use in search
	    DEFAULT_PROFILE_FIELDS  = ['education', 'positions']

        # By default, don't set an application ID
	    DEFAULT_CLIENT_ID = nil

	    # By default, don't set an application secret
	    DEFAULT_CLIENT_SECRET = nil

	    attr_accessor *VALID_OPTIONS_KEYS

	    # When this module is extended, set all configuration options to their default values
	    def self.extended(base)
	      base.reset
	    end

        def configure
	      yield self
	    end

	    # Create a hash of options and their values
	    def options
	      VALID_OPTIONS_KEYS.inject({}) do |option, key|
	        option.merge!(key => send(key))
	      end
	    end

		# Reset all configuration options to defaults
	    def reset
	      self.adapter        = DEFAULT_ADAPTER
	      self.access_token   = DEFAULT_ACCESS_TOKEN
	      self.endpoint       = DEFAULT_ENDPOINT
	      self.format         = DEFAULT_FORMAT
	      self.user_agent     = DEFAULT_USER_AGENT
	      self.default_profile_fields = DEFAULT_PROFILE_FIELDS
	    end
	end
end