module Gateway
  class Base
    include Callable

    def call
      raise NotImplementedError
    end

    protected

    def request(method, path, payload={})
      RestClient::Request.execute(
        method: method, 
        url: request_url(path),
        max_redirects: 0,
        payload: as_json(payload),
        headers: request_headers,
        log: Rails.env.development? ? Logger.new(STDOUT) : nil,
      )
    end

    private

    def request_headers
      {
        "Accept" => "application/json",
        "Content-Type" => "application/json",
        "App-Id" => ENV["APP_ID"],
        "Secret" => ENV["SECRET"]
      }
    end

    def request_url(*args)
      URI.join(ENV["API_URL"], args.join("/")).to_s
    end

    def as_json(payload)
      return "" if payload.blank?
 
      payload.to_json
    end
  end
end
