class Api::V1::RemoteServices::MediaController < Api::V1::RemoteServices::BaseController
  before_action :authenticate_access!, :set_medium

  def show
    success_response_with_top_level_message(MediumSerializer.new(@medium))
  end

  def destroy
    return error_response({ errors: 'can\'t delete medium tagged as media bin' }, :unprocessable_entity) if @medium.media_bin

    @medium.destroy
    render json: { message: 'Successfully removed' }, status: :ok
  end

  private

  def set_medium
    @medium = Medium.where(id: params[:id]).first
    error_response({ errors: 'can\'t find medium' }, :not_found) if @medium.nil?
  end
end
