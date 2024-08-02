# frozen_string_literal: true

class AuthenticationTokenService
  HMAC_SECRET = ENV['DEVISE_JWT_SECRET_KEY']
  ALGORITHM_TYPE = 'HS256'

  attr_reader :token

  def initialize(token)
    @token = token
  end

  def valid?
    error.nil?
  end

  def error
    @error ||= if token.nil?
                 'You need to sign in or sign up before continuing.'
               elsif !redis.hexists(token, 'user_id')
                 verify_auth_token
               end
  end

  def user_id
    redis.hget(token, 'user_id')
  end

  private

  def verify_auth_token
    return auth_service_response.result['error'] unless auth_service_response.valid?

    redis.hmset(token, 'user_id', auth_service_response.result['data']['id'])
    redis.expire(token, expire_in)
    nil
  end

  def auth_service_response
    @auth_service_response ||= AuthenticationService.new(token)
  end

  def expire_in
    in_seconds = Time.zone.at(decoded_token[0]['exp']).to_i - Time.zone.now.to_i
    [0, in_seconds].max
  end

  def decoded_token
    JWT.decode(token, HMAC_SECRET, true, { algorithm: ALGORITHM_TYPE })
  end

  def redis
    $redis
  end
end