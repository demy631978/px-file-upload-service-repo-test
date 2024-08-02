require 'rails_helper'

RSpec.describe AuthenticationTokenService do
  let(:user_id) { SecureRandom.uuid }
  let(:token) { jwt_encode(user_id) }
  let(:auth_token) { described_class.new(token) }
  let(:auth_token_with_nil_token) { described_class.new(nil) }

  let(:valid_auth_service) do
    allow_any_instance_of(AuthenticationService).to receive(:status).and_return(200)
    allow_any_instance_of(AuthenticationService).to receive(:result).and_return({ 'data' => { 'id' => user_id } })
  end

  let(:invalid_auth_service) do
    allow_any_instance_of(AuthenticationService).to receive(:status).and_return(401)
    allow_any_instance_of(AuthenticationService).to receive(:result).and_return({ 'error' => 'Signature verification raised' })
  end

  describe '#valid?' do
    context 'when token is nil' do
      it { expect(auth_token_with_nil_token.valid?).to be false }
    end

    context 'when verification of auth token failed' do
      it do
        invalid_auth_service
        expect(auth_token.valid?).to be false
      end
    end

    context 'when verification of auth token successful' do
      it do
        valid_auth_service
        expect(auth_token.valid?).to be true
      end
    end

    context 'when token already saved on Redis' do
      it do
        $redis.hmset(token, 'user_id', user_id)
        $redis.expire(token, 1)
        expect(auth_token.valid?).to be true
      end
    end
  end

  describe '#error' do
    context 'when token is nil' do
      it { expect(auth_token_with_nil_token.error).to eq 'You need to sign in or sign up before continuing.' }
    end

    context 'when verification of auth token failed' do
      it do
        invalid_auth_service
        expect(auth_token.error).to eq 'Signature verification raised'
      end
    end

    context 'when verification of auth token successful' do
      it do
        valid_auth_service
        expect(auth_token.error).to be_nil
      end
    end

    context 'when token already saved on Redis' do
      it do
        $redis.hmset(token, 'user_id', user_id)
        $redis.expire(token, 1)
        expect(auth_token.error).to be_nil
      end
    end
  end

  describe '#user_id' do
    context 'with valid request' do
      it do
        $redis.hmset(token, 'user_id', user_id)
        $redis.expire(token, 1)
        expect(auth_token.user_id).to eq user_id
      end
    end

    context 'with invalid request' do
      it { expect(auth_token_with_nil_token.user_id).to be_nil }
    end
  end
end