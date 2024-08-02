# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Px::Medium::DestroyService do
  let(:user_id) { SecureRandom.uuid }
  let(:image_file) { fixture_file_upload('image.png') }
  let(:medium1) { create(:medium, user_id: user_id) }
  let(:medium2) { create(:medium, user_id: user_id) }

  before { allow(MediumAttachment).to receive(:delete).and_return(true) }

  context 'with valid params' do
    before { described_class.run({ user_id: user_id, medium_ids: [medium1.id, medium2.id] }) }

    it { expect(Medium.exists?(medium1.id)).to be false }
    it { expect(Medium.exists?(medium2.id)).to be false }
  end

  context 'with invalid params' do
    it do
      response = described_class.run(medium_ids: 'test')
      expect(response.errors.full_messages).to eq ['User is required', 'Medium ids is not a valid array']
    end
  end

  context 'when medium_id does not exist' do
    let(:medium_id) { SecureRandom.uuid }
    let!(:response) { described_class.run({ user_id: user_id, medium_ids: [medium1.id, medium_id] }) }

    it { expect(response.errors.full_messages.first.downcase).to eq "#{medium_id} can't find medium" }
    it { expect(Medium.exists?(medium1.id)).to be true }
  end
end