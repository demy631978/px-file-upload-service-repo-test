# frozen_string_literal: true

class Api::V1::DirectUploadController < Api::V1::BaseController
  before_action :authenticate_user!

  def create
    outcome = DirectUploadService.run(params)

    if outcome.valid?
      success_response(outcome.result, :created)
    else
      error_response(ErrorSerializer.serialize(outcome).to_json, :unprocessable_entity)
    end
  end

  private

  def blob_params
    params.require(:file).permit(:filename, :byte_size, :checksum, :content_type, metadata: {})
  end
end