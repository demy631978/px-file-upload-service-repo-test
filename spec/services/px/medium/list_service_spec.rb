# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Px::Medium::ListService do
  let(:user_id) { SecureRandom.uuid }
  let(:image_file) { fixture_file_upload('image.png') }
  let!(:medium1) { create(:medium, user_id: user_id, media_bin: true) }
  let!(:medium2) { create(:medium, user_id: user_id, file_type: 'video') }

  context 'without file_type and media_bin attr' do
    it do
      response = described_class.run({ user_id: user_id })
      expect(response.result.to_hash.to_json).to eq MediumSerializer.new([medium2, medium1]).to_hash.to_json
    end
  end

  context 'with file_type attr' do
    it do
      response = described_class.run({ user_id: user_id, file_type: 'video' })
      expect(response.result.to_hash.to_json).to eq MediumSerializer.new([medium2], { meta: { tags: [], total: 1 } }).to_hash.to_json
    end
  end

  context 'with media_bin attr' do
    it do
      response = described_class.run({ user_id: user_id, media_bin: true })
      expect(response.result.to_hash.to_json).to eq MediumSerializer.new([medium1]).to_hash.to_json
    end
  end
end