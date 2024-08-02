require 'rails_helper'

RSpec.describe 'Generate public presigned S3 URL', type: :request do
  let(:user_id) { SecureRandom.uuid }
  let(:medium) { create(:medium, transcoded: true, file_type: 'video') }

  let(:authenticate_header) do
    allow_any_instance_of(AuthenticationService).to receive(:status).and_return(200)
    allow_any_instance_of(AuthenticationService).to receive(:result).and_return({ 'data' => { 'id' => user_id } })
    { 'Authorization' => "Bearer #{jwt_encode(user_id)}" }
  end

  describe 'POST /v1/media/:medium_id/public_direct_upload' do
    context 'with valid Authorization token and valid params' do
      before { post "/v1/media/#{medium.id}/public_direct_upload", params: { content_type: 'jpg' }, headers: authenticate_header }

      it { expect(response).to have_http_status(:created) }
      it { expect(response.body).to include "https://#{ENV['AWS_PUBLIC_BUCKET']}.s3.us-west-1.amazonaws.com/#{medium.attachment.key}.0000000.jpg" }
    end

    context 'with invalid params' do
      before { post "/v1/media/#{medium.id}/public_direct_upload", params: { content_type: 'test' }, headers: authenticate_header }

      it { expect(response).to have_http_status(:unprocessable_entity) }
      it { expect(response.body).to eq '{"errors":{"content_type":["is not included in the list"],"base":["Video medium only available to jpg or mp4 content_type"]}}' }
    end

    context 'with invalid Authorization token' do
      before { post "/v1/media/#{medium.id}/public_direct_upload" }

      it { expect(response).to have_http_status(:unauthorized) }
      it { expect(response.body).to eq '{"error":"You need to sign in or sign up before continuing."}' }
    end

    context 'when medium does not exist' do
      before { post '/v1/media/test-id/public_direct_upload', headers: authenticate_header }

      it { expect(response).to have_http_status(:not_found) }
      it { expect(response.body).to eq "{\"errors\":\"can't find medium\"}" }
    end
  end
end