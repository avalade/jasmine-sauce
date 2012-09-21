require 'guard/jasmine/server'

module Sauce
  module Jasmine
    class Server
      attr_reader :port, :host

      def initialize(config)
        @config = config
        @host = "127.0.0.1"
      end

      def start
        ::Guard::Jasmine::Server.start(@config.server, @config.port, 'test', 'spec/javascripts')
      end

      def stop
        # nothing, yet
      end
    end
  end
end
