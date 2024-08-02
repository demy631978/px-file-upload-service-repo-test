require 'rails_helper'

RSpec.describe 'Media#index', type: :request do
  let(:user_id) { SecureRandom.uuid }
  let(:medium) { create(:medium, user_id: user_id) }
  let(:medium2) { create(:medium, user_id: user_id, file_type: 'video') }

  let(:authenticate_header) do
    allow_any_instance_of(AuthenticationService).to receive(:status).and_return(200)
    allow_any_instance_of(AuthenticationService).to receive(:result).and_return({ 'data' => { 'id' => user_id } })
    { 'Authorization' => "Bearer #{jwt_encode(user_id)}" }
  end

  describe 'GET /v1/media' do
    context 'with valid Authorization token' do
      before do
        medium
        medium2
      end

      context 'when file_type params is not set' do
        before { get '/v1/media', headers: authenticate_header }

        it { expect(response).to have_http_status(:ok) }
        it { expect(JSON.parse(response.body)).to eq JSON.parse(MediumSerializer.new([medium2, medium]).to_hash.to_json) }
      end

      context 'when file_type params is set' do
        before { get '/v1/media?file_type=image', headers: authenticate_header }

        it { expect(response).to have_http_status(:ok) }
        it { expect(JSON.parse(response.body)).to eq JSON.parse(MediumSerializer.new([medium]).to_hash.merge({ meta: { tags: [], total: 1 } }).to_json) }
      end

      context 'with user_id param' do
        let(:user_id2) { SecureRandom.uuid }
        let!(:medium3) { create(:medium, user_id: user_id2) }

        before { get '/v1/media', params: { user_id: user_id2 }, headers: authenticate_header }

        it { expect(response).to have_http_status(:ok) }
        it { expect(JSON.parse(response.body)).to eq JSON.parse(MediumSerializer.new([medium3]).to_hash.to_json) }
      end
    end

    context 'with invalid Authorization token' do
      before { get '/v1/media' }

      it { expect(response).to have_http_status(:unauthorized) }
      it { expect(response.body).to eq '{"error":"You need to sign in or sign up before continuing."}' }
    end
  end
end