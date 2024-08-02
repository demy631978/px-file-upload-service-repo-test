require 'rails_helper'

RSpec.describe 'DirectUpload#create', type: :request do
  let(:user_id) { SecureRandom.uuid }
  let(:authenticate_header) do
    allow_any_instance_of(AuthenticationService).to receive(:status).and_return(200)
    allow_any_instance_of(AuthenticationService).to receive(:result).and_return({ 'data' => { 'id' => user_id } })
    { 'Authorization' => "Bearer #{jwt_encode(user_id)}" }
  end

  describe 'POST /v1/presigned_url' do
    context 'with valid Authorization token and valid params' do
      before { post '/v1/presigned_url', params: { byte_size: 104_788, checksum: 'ikyyD9/MweX/roZkFzB3kA==', filename: 'profile1.jpeg', content_type: 'image/jpeg' }, headers: authenticate_header }

      it 'returns a http status if :created' do
        expect(response).to have_http_status(:created)
      end

      it 'returns JSON response' do
        expect(response.body).to include 'https://test.com/rails/active_storage/disk/'
      end
    end

    context 'with valid Authorization token and invalid params' do
      before { post '/v1/presigned_url', params: { byte_size: 104_788, checksum: '', filename: '', content_type: '' }, headers: authenticate_header }

      it 'returns http status of :unprocessable_entity' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns error' do
        expect(response.body).to eq "{\"errors\":{\"checksum\":[\"can't be blank\"],\"filename\":[\"can't be blank\"],\"content_type\":[\"can't be blank\"]}}"
      end
    end

    context 'with invalid Authorization token' do
      it 'returns http status of :unauthorized' do
        post '/v1/presigned_url'
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end