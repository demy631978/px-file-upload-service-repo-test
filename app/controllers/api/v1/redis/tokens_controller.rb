# frozen_string_literal: true

class Api::V1::Redis::TokensController < Api::V1::BaseController
  before_action :authenticate_access!

  def destroy
    return render json: { errors: 'token can\'t be blank' }, status: :unprocessable_entity if params[:token].blank?

    $redis.hdel(params[:token], 'user_id')
    render json: { message: 'Successfully revoked' }, status: :ok
  end
end
