require 'cgi'

module LinkedIn

  class Client
    include Helpers::Request
    include Helpers::Authorization
    include Api::QueryMethods
    include Api::UpdateMethods
    include Search

    attr_accessor *Configuration::VALID_OPTIONS_KEYS

    #pass a hash of options to override default configuration
    def initialize(options={})
        options = LinkedIn.options.merge(options)
        Configuration::VALID_OPTIONS_KEYS.each do |key|
          send("#{key}=", options[key])
        end
    end

    #
    # def current_status
    #   path = "/people/~/current-status"
    #   Crack::XML.parse(get(path))['current_status']
    # end
    #
    # def network_statuses(options={})
    #   options[:type] = 'STAT'
    #   network_updates(options)
    # end
    #
    # def network_updates(options={})
    #   path = "/people/~/network"
    #   Network.from_xml(get(to_uri(path, options)))
    # end
    #
    # # helpful in making authenticated calls and writing the
    # # raw xml to a fixture file
    # def write_fixture(path, filename)
    #   file = File.new("test/fixtures/#{filename}", "w")
    #   file.puts(access_token.get(path).body)
    #   file.close
    # end

  end

end
