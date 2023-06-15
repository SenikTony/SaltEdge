module Gateway
  module Consents
    class ShowService < Base
      def initialize(connection:)
        @gateway_path = "consents"
        @connection = connection
      end

      def call
        response = request("GET", request_path)
        JSON.parse(response.body).deep_symbolize_keys
      rescue RestClient::ExceptionWithResponse => e
        JSON.parse(e.response.body).deep_symbolize_keys
      end

      private

      attr_reader :connection, :gateway_path

      def request_path
        [gateway_path, connection.last_consent_id, "?connection_id=#{connection.connection_id}"]
      end
    end
  end
end