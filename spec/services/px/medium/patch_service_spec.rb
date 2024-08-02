# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Px::Medium::PatchService do
  let(:image_file) { fixture_file_upload('image.png') }
  let(:medium) { create(:medium) }

  let(:valid_params) do
    {
      medium: medium,
      modified_attachment: image_file,
      file_name: 'test file name',
      tag_list: 'test1, test2',
      modified_metadata: { file_size: 1234 },
      visible: false,
      media_bin: true,
      duration: '1:00',
      label: 'Label 1',
      modified_duration: '2:00'
    }
  end
  let(:invalid_params) do
    {
      medium: medium,
      modified_attachment: image_file,
      file_name: '',
      tag_list: 'test1, test2',
      modified_metadata: { file_size: 1234 },
      visible: false,
      media_bin: true,
      duration: '1:00'
    }
  end

  let(:valid_patch_record) { described_class.run(valid_params) }
  let(:invalid_patch_record) { described_class.run(invalid_params) }

  context 'with valid attributes' do
    before { valid_patch_record }

    it { expect(medium.modified_attachment.present?).to be true }
    it { expect(medium.file_name).to eq valid_params[:file_name] }
    it { expect(medium.tag_list).to eq %w[test1 test2] }
    it { expect(medium.modified_metadata).to eq({ 'file_size' => 1234 }) }
    it { expect(medium.visible).to eq valid_params[:visible] }
    it { expect(medium.media_bin).to eq valid_params[:media_bin] }
    it { expect(medium.duration).to eq valid_params[:duration] }
    it { expect(medium.label).to eq valid_params[:label] }
    it { expect(medium.modified_duration).to eq valid_params[:modified_duration] }

  end

  context 'with invalid attributes' do
    it { expect(invalid_patch_record.errors.full_messages).to eq ["File name can't be blank"] }
  end
end
