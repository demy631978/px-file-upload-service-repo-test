# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Errors#not_found', type: :request do
  describe 'rescue routing error' do
    before { get '/unknown-api-endpoint' }

    it 'returns http status of :not_found' do
      expect(response).to have_http_status(:not_found)
    end

    it 'returns error' do
      expect(response.body).to eq "{\"errors\":\"endpoint doesn't exist or missing path variable value\"}"
    end
  end
end