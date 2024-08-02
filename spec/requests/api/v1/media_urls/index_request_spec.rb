require 'rails_helper'

RSpec.describe 'MediaUrls#index', type: :request do
  let(:medium) { create(:medium) }
  let(:medium2) { create(:medium) }

  describe 'GET /v1/media_urls' do
    before { get '/v1/media_urls', params: { ids: [medium.id, medium2.id] } }

    it { expect(response).to have_http_status(:ok) }
    it { expect(JSON.parse(response.body)['data'].count).to eq 2 }
  end
end