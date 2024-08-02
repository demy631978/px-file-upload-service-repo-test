require 'rails_helper'

RSpec.describe 'Media#create', type: :request do
  let(:user_id) { SecureRandom.uuid }
  let(:image_file) { fixture_file_upload('image.png') }

  let(:authenticate_header) do
    allow_any_instance_of(AuthenticationService).to receive(:status).and_return(200)
    allow_any_instance_of(AuthenticationService).to receive(:result).and_return({ 'data' => { 'id' => user_id } })
    { 'Authorization' => "Bearer #{jwt_encode(user_id)}" }
  end

  let(:params) do
    {
      attachment: image_file,
      modified_attachment: image_file,
      file_type: 'image',
      file_name: 'image.png',
      file_size: 123.13,
      file_height: 100,
      file_width: 100,
      transcoded: true,
      modified_metadata: { file_size: 1234 }
    }
  end

  describe 'POST /v1/media' do
    context 'with valid Authorization token' do
      before { post '/v1/media', params: params, headers: authenticate_header }

      it { expect(response).to have_http_status(:created) }
      it { expect(JSON.parse(response.body)).to eq JSON.parse(MediumSerializer.new(Medium.where(user_id: user_id).last).serializable_hash.merge({ message: 'Success' }).to_json) }
    end

    context 'with user_id param' do
      let(:user_id2) { SecureRandom.uuid }

      before { post '/v1/media', params: params.merge(user_id: user_id2), headers: authenticate_header }

      it { expect(response).to have_http_status(:created) }
      it { expect(JSON.parse(response.body)).to eq JSON.parse(MediumSerializer.new(Medium.where(user_id: user_id2).last).serializable_hash.merge({ message: 'Success' }).to_json) }
    end

    context 'with invalid Authorization token' do
      before { post '/v1/media', params: { attachment: image_file } }

      it { expect(response).to have_http_status(:unauthorized) }
      it { expect(response.body).to eq '{"error":"You need to sign in or sign up before continuing."}' }
    end

    context 'with invalid params' do
      before { post '/v1/media', params: { attachment: image_file, file_type: 'image' }, headers: authenticate_header }

      it { expect(response).to have_http_status(:unprocessable_entity) }
      it { expect(response.body).to eq "{\"errors\":{\"file_name\":[\"can't be blank\"],\"file_size\":[\"can't be blank\"],\"file_width\":[\"can't be blank\"],\"file_height\":[\"can't be blank\"]}}" }
    end
  end
end