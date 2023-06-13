module Gateway
  module Connections
    class RefreshService < Base
      def initialize(connection:)
        @connection = connection
      end

      def call
        response = request("PUT", request_path)
        JSON.parse(response.body).deep_symbolize_keys
      rescue RestClient::ExceptionWithResponse => e
        JSON.parse(e.response.body).deep_symbolize_keys
      end

      private

      attr_reader :connection

      def request_path
        ["connections", connection.connection_id, "refresh"]
      end
    end
  end
end