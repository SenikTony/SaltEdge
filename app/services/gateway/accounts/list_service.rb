module Gateway
  module Accounts
    class ListService < Base
      def initialize(connection:, from_id: "")
        @gateway_path = "accounts"
        @connection = connection
      end

      def call
        response = request("GET", request_path)
        JSON.parse(response.body).deep_symbolize_keys
      rescue RestClient::ExceptionWithResponse => e
        JSON.parse(e.response.body).deep_symbolize_keys
      end

      private

      attr_reader :connection, :from_id, :gateway_path

      def request_path
        params = ["connection_id=#{connection.connection_id}"]
        params << "from_id=#{from_id}" if from_id.present?

        [gateway_path, "?#{params.join("&")}"]
      end
    end
  end
end