class Api::V1::MediaController < Api::V1::BaseController
  before_action :authenticate_user!, except: :show
  before_action :set_medium, only: :update

  def index
    input = params[:user_id].blank? ? { user_id: current_user_id }.reverse_merge(params) : params
    outcome = Px::Medium::ListService.run(input)

    success_response(outcome.result)
  end

  def show
    medium = Medium.find_by(id: params[:id])
    return head :not_found if medium.nil?

    outcome = Px::Medium::ShowService.run({ medium: medium }.reverse_merge(params))
    return error_response(ErrorSerializer.serialize(outcome).to_json, :unprocessable_entity) unless outcome.valid?
    return success_response(outcome.result) if params[:redirect] == 'false'

    redirect_to outcome.result, allow_other_host: true
  end

  def create
    medium = nil
    ActiveRecord::Base.transaction do
      medium = Medium.create(create_media_params)
    end
    return error_response(ErrorSerializer.serialize(medium).to_json, :unprocessable_entity) unless medium.valid?

    success_response_with_top_level_message(MediumSerializer.new(medium), :created)
  rescue => e
    error_response({ errors: e.message }, :unprocessable_entity)
  end

  def update
    inputs = { medium: @medium }.reverse_merge(params)
    outcome = Px::Medium::PatchService.run(inputs)

    if outcome.valid?
      success_response_with_top_level_message(outcome.result)
    else
      error_response(ErrorSerializer.serialize(outcome).to_json, :unprocessable_entity)
    end
  end

  def destroy
    outcome = Px::Medium::DestroyService.run(user_id: current_user_id, medium_ids: params[:medium_ids])
    return error_response(ErrorSerializer.serialize(outcome).to_json, :unprocessable_entity) unless outcome.valid?

    render json: { message: 'Successfully removed' }, status: :ok
  end

  private

  def create_media_params
    params[:user_id] = current_user_id if params[:user_id].blank?
    params[:modified_metadata] = JSON.parse(params[:modified_metadata]) if params[:modified_metadata].present? && !params[:modified_metadata].instance_of?(::Hash)
    params.permit(
      :attachment,
      :modified_attachment,
      :file_type,
      :file_name,
      :file_size,
      :file_width,
      :file_height,
      :transcoded,
      :tag_list,
      :media_bin,
      :duration,
      :modified_duration,
      :label,
      :user_id,
      modified_metadata: {}
    )
  end

  def set_medium
    @medium = Medium.where(id: params[:id], user_id: params[:user_id].presence || current_user_id).first
    error_response({ errors: 'can\'t find medium' }, :not_found) if @medium.nil?
  end
end
