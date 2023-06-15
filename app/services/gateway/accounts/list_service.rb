module Gateway
  module Accounts
    class ListService < Base
      def initialize(customer:, connection:, from_id: "")
        @gateway_path = "accounts"
        @connection = connection
        @customer = customer
      end

      def call
        r = request("GET", request_path)
        JSON.parse(r.body)
      rescue RestClient::ExceptionWithResponse => e
        JSON.parse(e.response.body)
      end

      private

      attr_reader :connection, :customer, :from_id, :gateway_path

      def request_path
        # validation here need customer <- connections
        params = ["connection_id=#{connection}"]
        params << "from_id=#{from_id}" if from_id.present?

        "#{gateway_path}/?#{params.join("&")}"
      end
    end
  end
end