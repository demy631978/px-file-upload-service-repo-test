module JwtHelper
  def jwt_encode(user_id)
    payload = { sub: user_id, exp: 8.days.from_now.to_i }
    JWT.encode payload, AuthenticationTokenService::HMAC_SECRET, AuthenticationTokenService::ALGORITHM_TYPE
  end
end