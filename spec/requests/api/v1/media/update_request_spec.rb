require 'rails_helper'

RSpec.describe 'Media#update', type: :request do
  let(:user_id) { SecureRandom.uuid }
  let(:image_file) { fixture_file_upload('image.png') }
  let(:medium) { create(:medium, user_id: user_id) }
  let(:medium2) { create(:medium, user_id: SecureRandom.uuid) }

  let(:authenticate_header) do
    allow_any_instance_of(AuthenticationService).to receive(:status).and_return(200)
    allow_any_instance_of(AuthenticationService).to receive(:result).and_return({ 'data' => { 'id' => user_id } })
    { 'Authorization' => "Bearer #{jwt_encode(user_id)}" }
  end

  let(:valid_params) do
    {
      modified_attachment: image_file,
      file_name: 'test file name',
      tag_list: 'test1, test2',
      modified_metadata: { file_size: 1234 },
      visible: false,
      label: 'Label 1'
    }
  end

  describe 'PATCH /v1/media/:id' do
    context 'with valid Authorization token' do
      before { patch "/v1/media/#{medium.id}", params: valid_params, headers: authenticate_header }

      it { expect(response).to have_http_status(:ok) }
      it { expect(JSON.parse(response.body)).to eq JSON.parse(MediumSerializer.new(medium.reload).serializable_hash.merge({ message: 'Success' }).to_json) }
    end

    context 'with invalid Authorization token' do
      before { patch "/v1/media/#{medium2.id}" }

      it { expect(response).to have_http_status(:unauthorized) }
      it { expect(response.body).to eq '{"error":"You need to sign in or sign up before continuing."}' }
    end

    context 'with invalid params' do
      before { patch "/v1/media/#{medium.id}", params: { file_name: '' }, headers: authenticate_header }

      it { expect(response).to have_http_status(:unprocessable_entity) }
      it { expect(response.body).to eq "{\"errors\":{\"file_name\":[\"can't be blank\"]}}" }
    end

    context 'when medium does not belong to current user' do
      before { patch "/v1/media/#{medium2.id}", params: valid_params, headers: authenticate_header }

      it { expect(response).to have_http_status(:not_found) }
      it { expect(response.body).to eq "{\"errors\":\"can't find medium\"}" }
    end

    context 'with user_id param' do
      before do
        valid_params[:user_id] = medium2.user_id
        patch "/v1/media/#{medium2.id}", params: valid_params, headers: authenticate_header
      end

      it { expect(response).to have_http_status(:ok) }
      it { expect(JSON.parse(response.body)).to eq JSON.parse(MediumSerializer.new(medium2.reload).serializable_hash.merge({ message: 'Success' }).to_json) }
    end
  end
end
