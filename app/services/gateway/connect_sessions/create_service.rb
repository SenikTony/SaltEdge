module Gateway
  module ConnectSessions
    class CreateService < Base
      def initialize(user:, callback_url:)
        @user = user
        @callback_url = callback_url
      end

      def call
        api_response = request("POST", %w[connect_sessions create], params)
        JSON.parse(api_response.body).deep_symbolize_keys
      rescue RestClient::ExceptionWithResponse => e
        JSON.parse(e.response.body).deep_symbolize_keys
      end

      private

      attr_reader :user, :callback_url

      def params
        {
          data: {
            customer_id: user.gateway_id,
            consent: {
              from_date: Date.current.to_s,
              period: 90,
              scopes: %w[account_details transactions_details]
            },
            attempt: {
              from_date: Date.current.to_s,
              return_to: callback_url,
              fetch_scopes: %w[accounts transactions]
            }
          }
        }
      end
    end
  end
end
