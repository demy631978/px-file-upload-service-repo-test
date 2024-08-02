require 'rails_helper'

RSpec.describe 'Media#destroy', type: :request do
  let(:user_id) { SecureRandom.uuid }
  let(:medium) { create(:medium, user_id: user_id) }
  let(:authenticate_header) { { 'Authorization' => "Bearer #{ENV['API_KEYS']}" } }

  describe 'DELETE /v1/remote_services/media/:id' do
    context 'with valid Authorization token' do
      before { delete "/v1/remote_services/media/#{medium.id}", headers: authenticate_header }

      it { expect(response).to have_http_status(:ok) }
      it { expect(response.body).to eq '{"message":"Successfully removed"}' }

      it 'removes medium' do
        expect(Medium.count).to eq 0
      end
    end

    context 'with medium taggged as media bin' do
      before do
        medium.update(media_bin: true)
        delete "/v1/remote_services/media/#{medium.id}", headers: authenticate_header
      end

      it { expect(response).to have_http_status(:unprocessable_entity) }
      it { expect(response.body).to eq "{\"errors\":\"can't delete medium tagged as media bin\"}" }

      it 'does not delete medium' do
        expect(Medium.count).to eq 1
      end
    end

    context 'with invalid Authorization token' do
      before { delete "/v1/remote_services/media/#{medium.id}" }

      it { expect(response).to have_http_status(:unauthorized) }
      it { expect(response.body).to eq '{"errors":"Invalid API key"}' }
    end

    context 'when medium does not exist' do
      before { delete '/v1/remote_services/media/unknown-medium', headers: authenticate_header }

      it { expect(response).to have_http_status(:not_found) }
      it { expect(response.body).to eq "{\"errors\":\"can't find medium\"}" }
    end
  end
end