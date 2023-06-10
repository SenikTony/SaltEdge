module Gateway
  module Customers
    class RemoveService < Base
      def initialize(gateway_id:)
        @gateway_id = gateway_id
      end

      def call
        api_response = request("DELETE", "customers/#{gateway_id}")
        JSON.parse(api_response.body).deep_symbolize_keys
      rescue RestClient::ExceptionWithResponse => e
        JSON.parse(e.response.body).deep_symbolize_keys
      end

      private

      attr_reader :gateway_id
    end
  end
end
