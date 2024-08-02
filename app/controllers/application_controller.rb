# frozen_string_literal: true

class ApplicationController < ActionController::Base
  rescue_from ActionDispatch::Http::Parameters::ParseError, with: :wrong_params_format

  protect_from_forgery with: :null_session

  def authenticate_user!
    error_response({ error: auth_token.error }, :unauthorized) unless auth_token.valid?
  end

  def authenticate_access!
    error_response({ errors: 'Invalid API key' }, :unauthorized) if api_keys.exclude?(access_token)
  end

  def success_response(response_success_payload, status_code = :ok)
    render json: response_success_payload, status: status_code
  end

  def success_response_with_top_level_message(serialized_object, status_code = :ok, message = 'Success')
    serialized_hash = serialized_object.serializable_hash
    serialized_hash['message'] = message
    render json: serialized_hash, status: status_code
  end

  def error_response(response_error_payload, status_code)
    render json: response_error_payload, status: status_code
  end

  private

  def wrong_params_format
    error_response({ data: { base: ['invalid body format'] } }, :unprocessable_entity)
  end

  def access_token
    @access_token ||= authenticate_with_http_token { |token, _options| token }
  end

  def api_keys
    ENV['API_KEYS'].split(',')
  end

  def current_user_id
    @current_user_id ||= auth_token.user_id
  end

  def auth_token
    @auth_token ||= AuthenticationTokenService.new(access_token)
  end
end
