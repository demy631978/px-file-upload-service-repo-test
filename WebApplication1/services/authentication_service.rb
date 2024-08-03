# frozen_string_literal: true

class AuthenticationService
  SERVICE_DOMAIN = ENV['AUTH_SERVICE_DOMAIN']

  attr_reader :result, :status

  def initialize(token)
    response = faraday_connection.get('/v1/verify_access_token', {}, 'Authorization' => "Bearer #{token}")
    @status = response.status
    @result = response.body
  end

  def valid?
    status.to_i == 200
  end

  private

  def faraday_connection
    Faraday.new(SERVICE_DOMAIN) do |f|
      f.response :json
      f.request :url_encoded
      f.adapter :net_http
    end
  end
end