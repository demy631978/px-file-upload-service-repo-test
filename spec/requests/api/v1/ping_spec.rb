## frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Ping', type: :request do
  describe 'GET /index' do
    before do
      get '/v1/ping' # or /ping
    end

    it 'returns http status ok' do
      expect(response).to have_http_status(:ok)
    end

    it 'responds pong message' do
      expect(JSON.parse(response.body)['message']).to eq 'Pong!!!'
    end
  end
end
