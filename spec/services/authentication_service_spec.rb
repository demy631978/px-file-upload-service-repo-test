require 'rails_helper'

RSpec.describe AuthenticationService do
  let(:user_id) { SecureRandom.uuid }
  let(:token) { jwt_encode(user_id) }
  let(:auth_sevice) { described_class.new(token) }

  let(:valid_auth_service) do
    allow_any_instance_of(described_class).to receive(:status).and_return(200)
    allow_any_instance_of(described_class).to receive(:result).and_return({ 'data' => { 'id' => user_id } })
  end

  let(:invalid_auth_service) do
    allow_any_instance_of(described_class).to receive(:status).and_return(401)
    allow_any_instance_of(described_class).to receive(:result).and_return({ 'error' => 'Signature verification raised' })
  end

  describe '.status' do
    context 'with valid request' do
      it do
        valid_auth_service
        expect(auth_sevice.status).to eq 200
      end
    end

    context 'with invalid request' do
      it do
        invalid_auth_service
        expect(auth_sevice.status).to eq 401
      end
    end
  end

  describe '.result' do
    context 'with valid request' do
      it do
        valid_auth_service
        expect(auth_sevice.result).to eq({ 'data' => { 'id' => user_id } })
      end
    end

    context 'with invalid request' do
      it do
        invalid_auth_service
        expect(auth_sevice.result).to eq({ 'error' => 'Signature verification raised' })
      end
    end
  end

  describe '#valid?' do
    context 'with valid request' do
      it do
        valid_auth_service
        expect(auth_sevice.valid?).to be true
      end
    end

    context 'with invalid request' do
      it do
        invalid_auth_service
        expect(auth_sevice.valid?).to be false
      end
    end
  end
end