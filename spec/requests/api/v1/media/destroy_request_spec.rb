require 'rails_helper'

RSpec.describe 'Delete multiple media', type: :request do
  let(:user_id) { SecureRandom.uuid }
  let(:medium1) { create(:medium, user_id: user_id) }
  let(:medium2) { create(:medium, user_id: user_id) }

  let(:authenticate_header) do
    allow_any_instance_of(AuthenticationService).to receive(:status).and_return(200)
    allow_any_instance_of(AuthenticationService).to receive(:result).and_return({ 'data' => { 'id' => user_id } })
    { 'Authorization' => "Bearer #{jwt_encode(user_id)}" }
  end

  before { allow(MediumAttachment).to receive(:delete).and_return(true) }

  describe 'DELETE /v1/media' do
    context 'with valid params and valid Authorization token' do
      before { delete '/v1/media', params: { medium_ids: [medium1.id, medium2.id] }, headers: authenticate_header }

      it { expect(response).to have_http_status(:ok) }
      it { expect(response.body).to eq '{"message":"Successfully removed"}' }
    end

    context 'with invalid params' do
      let(:medium_id) { SecureRandom.uuid }

      before { delete '/v1/media', params: { medium_ids: [medium1.id, medium_id] }, headers: authenticate_header }

      it { expect(response).to have_http_status(:unprocessable_entity) }
      it { expect(response.body).to eq "{\"errors\":{\"#{medium_id}\":[\"can't find medium\"]}}" }
    end

    context 'with invalid Authorization token' do
      before { delete '/v1/media' }

      it { expect(response).to have_http_status(:unauthorized) }
      it { expect(response.body).to eq '{"error":"You need to sign in or sign up before continuing."}' }
    end
  end
end