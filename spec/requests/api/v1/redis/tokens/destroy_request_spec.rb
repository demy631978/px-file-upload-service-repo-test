## frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Redis::Tokens#destroy', type: :request do
  let(:user_id) { SecureRandom.uuid }
  let(:token) { jwt_encode(user_id) }
  let(:authenticate_header) { { 'Authorization' => "Bearer #{ENV['API_KEYS']}" } }

  describe 'DELETE /v1/redis/tokens' do
    context 'with valid params' do
      before do
        $redis.hmset(token, 'user_id', user_id)
        delete '/v1/redis/tokens', params: { token: token }, headers: authenticate_header
      end

      it { expect(response).to have_http_status(:ok) }
      it { expect(response.body).to eq '{"message":"Successfully revoked"}' }

      it 'revokes the redis record' do
        expect($redis.hexists(token, 'user_id')).to be false
      end
    end

    context 'with invalid params' do
      before { delete '/v1/redis/tokens', headers: authenticate_header }

      it { expect(response).to have_http_status(:unprocessable_entity) }
      it { expect(response.body).to eq "{\"errors\":\"token can't be blank\"}" }
    end

    context 'with invalid access token' do
      before { delete '/v1/redis/tokens' }

      it { expect(response).to have_http_status(:unauthorized) }
      it { expect(response.body).to eq '{"errors":"Invalid API key"}' }
    end
  end
end