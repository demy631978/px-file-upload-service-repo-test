require 'rails_helper'

RSpec.describe 'Media#show', type: :request do
  let(:user_id) { SecureRandom.uuid }
  let(:medium) { create(:medium, user_id: user_id) }
  let(:authenticate_header) { { 'Authorization' => "Bearer #{ENV['API_KEYS']}" } }

  describe 'GET /v1/remote_services/media/:id' do
    context 'with valid Authorization token' do
      before { get "/v1/remote_services/media/#{medium.id}", headers: authenticate_header }

      it { expect(response).to have_http_status(:ok) }
      it { expect(JSON.parse(response.body)).to eq JSON.parse(MediumSerializer.new(medium.reload).serializable_hash.merge({ message: 'Success' }).to_json) }
    end

    context 'with invalid Authorization token' do
      before { get "/v1/remote_services/media/#{medium.id}" }

      it { expect(response).to have_http_status(:unauthorized) }
      it { expect(response.body).to eq '{"errors":"Invalid API key"}' }
    end

    context 'when medium does not exist' do
      before { get '/v1/remote_services/media/unknown-medium', headers: authenticate_header }

      it { expect(response).to have_http_status(:not_found) }
      it { expect(response.body).to eq "{\"errors\":\"can't find medium\"}" }
    end
  end
end