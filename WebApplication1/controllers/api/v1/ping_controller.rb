class Api::V1::PingController < Api::V1::BaseController
  def index
    success_response({ message: 'Pong!!!' }.to_json)
  end
end
