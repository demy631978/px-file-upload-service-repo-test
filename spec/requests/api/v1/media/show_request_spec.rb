require 'rails_helper'

RSpec.describe 'Media#show', type: :request do
  let(:medium) { create(:medium, user_id: SecureRandom.uuid) }

  describe 'GET /v1/media/:id' do
    context 'with no params' do
      before { get "/v1/media/#{medium.id}" }

      it { expect(response).to have_http_status(:found) }
      it { expect(response).to redirect_to(medium.attachment_url) }
    end

    context 'with redirect param' do
      before { get "/v1/media/#{medium.id}", params: { redirect: false } }

      it { expect(response).to have_http_status(:ok) }
      it { expect(response.body).to eq medium.attachment_url }
    end

    context 'when mediun does not exist' do
      it do
        get '/v1/media/unknown-medium'
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'GET /v1/media/:id/:dimension' do
    context 'with no params' do
      before { get "/v1/media/#{medium.id}/500x500" }

      it { expect(response).to have_http_status(:found) }
      it { expect(response).to redirect_to("#{medium.attachment_url}/500x500") }
    end

    context 'with redirect param' do
      before { get "/v1/media/#{medium.id}/500x500", params: { redirect: false } }

      it { expect(response).to have_http_status(:ok) }
      it { expect(response.body).to eq "#{medium.attachment_url}/500x500" }
    end

    context 'when mediun does not exist' do
      it do
        get '/v1/media/unknown-medium/500x500'
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end