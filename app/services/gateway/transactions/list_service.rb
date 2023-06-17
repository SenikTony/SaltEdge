module Gateway
  module Transactions
    class ListService < Base
      def initialize(connection:, account:, status: :posted, from_id: "")
        @gateway_path = status == :posted ? "transactions" : "transactions/pending"
        @connection = connection
        @account = account
      end

      def call
        response = request("GET", request_path)
        JSON.parse(response.body).deep_symbolize_keys
      rescue RestClient::ExceptionWithResponse => e
        JSON.parse(e.response.body).deep_symbolize_keys
      end

      private

      attr_reader :connection, :account, :from_id, :gateway_path

      def request_path
        params = ["connection_id=#{connection.connection_id}"]
        params << "account_id=#{account.account_id}"
        params << "from_id=#{from_id}" if from_id.present?

        [gateway_path, "?#{params.join("&")}"]
      end
    end
  end
end