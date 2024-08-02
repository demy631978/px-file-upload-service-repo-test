class Api::V1::MediaAggregatesController < Api::V1::BaseController
  before_action :authenticate_user!

  def index
    outcome = Px::MediaAggregate::ListService.run({ user_id: current_user_id })
    success_response(outcome.result)
  end
end