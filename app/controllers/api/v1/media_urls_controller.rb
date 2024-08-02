class Api::V1::MediaUrlsController < Api::V1::BaseController
  def index
    outcome = Px::MediaUrl::ListService.run(params)

    if outcome.valid?
      success_response(outcome.result)
    else
      error_response(ErrorSerializer.serialize(outcome).to_json, :unprocessable_entity)
    end
  end
end