module Gateway
  module Connections
    class ListService < Base
      def initialize(user:, from_id: "")
        @gateway_path = "connections"
        @user = user
      end

      def call
        response = request("GET", request_path)
        JSON.parse(response.body).deep_symbolize_keys
      rescue RestClient::ExceptionWithResponse => e
        JSON.parse(e.response.body).deep_symbolize_keys
      end

      private

      attr_reader :user, :from_id, :gateway_path

      def request_path
        params = ["customer_id=#{user.gateway_id}"]
        params << "from_id=#{from_id}" if from_id.present?

        [gateway_path, "?#{params.join("&")}"]
      end
    end
  end
end