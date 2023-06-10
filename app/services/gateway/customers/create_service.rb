module Gateway
  module Customers
    class CreateService < Base
      def initialize(user:)
        @user = user
      end

      def call
        api_response = request("POST", "customers/", { data: { identifier: user.email } })
        JSON.parse(api_response.body).deep_symbolize_keys
      rescue RestClient::ExceptionWithResponse => e
        JSON.parse(e.response.body).deep_symbolize_keys
      end

      private

      attr_reader :user
    end
  end
end
