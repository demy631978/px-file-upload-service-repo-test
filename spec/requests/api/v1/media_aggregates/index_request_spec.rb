require 'rails_helper'

RSpec.describe 'MediaAggregates#index', type: :request do
  let(:user_id) { SecureRandom.uuid }
  let(:image_file) { fixture_file_upload('image.png') }
  let(:medium) { create(:medium, user_id: user_id) }
  let(:medium2) { create(:medium, user_id: user_id, file_type: 'video') }

  let(:authenticate_header) do
    allow_any_instance_of(AuthenticationService).to receive(:status).and_return(200)
    allow_any_instance_of(AuthenticationService).to receive(:result).and_return({ 'data' => { 'id' => user_id } })
    { 'Authorization' => "Bearer #{jwt_encode(user_id)}" }
  end

  describe 'GET /v1/media_aggregates' do
    context 'with valid Authorization token' do
      before do
        medium
        medium2
        get '/v1/media_aggregates', headers: authenticate_header
      end

      it 'returns a http status if :ok' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns a JSON response' do
        expect(response.body).to eq '{"data":{"images_count":1,"videos_count":1,"audios_count":0,"documents_count":0,"storage_size_used":1053210,"images_limit":"Unlimited","videos_limit":"Unlimited","audios_limit":"Unlimited","documents_limit":"Unlimited","storage_size_limit":"Unlimited"},"message":"Success"}'
      end
    end

    context 'with invalid Authorization token' do
      it 'returns http status of :unauthorized' do
        get '/v1/media_aggregates'
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end