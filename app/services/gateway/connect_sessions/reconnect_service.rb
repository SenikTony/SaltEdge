module Gateway
  module ConnectSessions
    class ReconnectService < Base
      def initialize(connection:, callback_url:)
        @connection = connection
        @callback_url = callback_url
      end

      def call
        api_response = request("POST", %w[connect_sessions reconnect], params)
        JSON.parse(api_response.body).deep_symbolize_keys
      rescue RestClient::ExceptionWithResponse => e
        JSON.parse(e.response.body).deep_symbolize_keys
      end

      private

      attr_reader :connection, :callback_url

      def params
        {
          data: {
            connection_id: connection.connection_id,
            consent: {
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
