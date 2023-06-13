class ConnectionStateUpdateService
  include Callable

  AVAILABLE_KINDS = %w[refresh reconnect].freeze

  def initialize(connection:, kind:, callback_url:)
    @connection = connection
    @expires_at = nil
    @callback_url = callback_url
    @kind = kind
  end

  def call
    return unless AVAILABLE_KINDS.include?(kind)

    if refresh?
      puts "refresh"
      gateway_data = Gateway::Consents::ShowService.call(connection: connection)
      @expires_at = DateTime.parse(gateway_data[:expires_at]) if gateway_data[:expires_at].present?
      allow_refresh? ? Gateway::Connections::RefreshService.call(connection: connection) : false
    else
      puts "reconnect"
      gateway_data = Gateway::ConnectSessions::ReconnectService.call(connection: connection, callback_url: callback_url)
      gateway_data[:data][:connect_url]
    end
  rescue StandardError => e
    return false
  end

  private

  attr_reader :connection, :kind, :expires_at, :callback_url

  def refresh?
    AVAILABLE_KINDS[0] == kind
  end

  def reconnect?
    AVAILABLE_KINDS[1] == kind
  end

  def allow_refresh?
    @expires_at.blank? || @expires_at.present? && DateTime.current < @expires_at
  end
end
