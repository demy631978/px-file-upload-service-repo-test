# frozen_string_literal: true

class Api::V1::Media::PublicDirectUploadController < Api::V1::BaseController
  before_action :authenticate_user!,
                :set_medium

  def create
    outcome = PublicDirectUploadService.run(medium: @medium, content_type: params[:content_type])
    if outcome.valid?
      success_response({ direct_upload: { url: outcome.result } }, :created)
    else
      error_response(ErrorSerializer.serialize(outcome).to_json, :unprocessable_entity)
    end
  end

  private

  def set_medium
    @medium = Medium.find_by(id: params[:medium_id])
    error_response({ errors: 'can\'t find medium' }, :not_found) unless @medium
  end
end