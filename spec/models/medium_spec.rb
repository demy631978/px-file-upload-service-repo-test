require 'rails_helper'

RSpec.describe Medium, type: :model do
  let(:medium_build) { build(:medium) }

  describe 'Associations' do
    it { should have_one_attached :attachment }
  end

  describe 'Enum' do
    it { should define_enum_for(:file_type).with_values(image: 'Image', audio: 'Audio', video: 'Video', document: 'Document').backed_by_column_of_type(:string) }
  end

  describe 'Validations' do
    it { should validate_presence_of(:user_id).with_message('invalid UUID') }
    it { should validate_presence_of :attachment }
    it { should validate_presence_of :file_name }
    it { should validate_presence_of :file_size }
    it { should validate_inclusion_of(:file_type).in_array(described_class.file_types.keys + described_class.file_types.values) }

    context 'when file_type is image' do
      before { allow(subject).to receive(:image?).and_return(true) }

      it { should validate_presence_of :file_width }
      it { should validate_presence_of :file_height }
    end

    context 'when file_type is not image' do
      before { allow(subject).to receive(:image?).and_return(false) }

      it { should_not validate_presence_of :file_width }
      it { should_not validate_presence_of :file_height }
    end
  end

  describe 'Callbacks' do
    describe 'after_commit' do
      describe '#trigger_image_thumbnail_resizer_job' do
        let(:medium) { build(:medium, id: '9f4d2315-9295-4d2e-82a2-cbe0d32c210d') }

        it 'enqueues ImageThumbnailResizerJob if the medium is an image' do
          expect(ImageThumbnailResizerJob).to receive(:perform_later).with('9f4d2315-9295-4d2e-82a2-cbe0d32c210d')

          medium.save!
        end

        it 'does not enqueue ImageThumbnailResizerJob if the medium is not an image' do
          allow(medium).to receive(:image?).and_return(false)
          expect(ImageThumbnailResizerJob).not_to receive(:perform_later)

          medium.save!
        end
      end
    end
  end

  describe 'Instance Methods' do
    describe '#attachment_url' do
      context 'without raw_file param' do
        it { expect(create(:medium).attachment_url).to include 'https://test.com/rails/active_storage/blobs/redirect' }
      end

      context 'with raw_file param' do
        it { expect(create(:medium).attachment_url(raw_file: true)).to include 'https://test.com/rails/active_storage/blobs/redirect' }
      end
    end

    describe '#modified_attachment_url' do
      let(:medium) { create(:medium, modified_attachment: Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/image.png'), 'image/png')) }

      context 'without raw_file param' do
        it { expect(medium.modified_attachment_url).to include('https://test.com/rails/active_storage/blobs/redirect') }
      end

      context 'with raw_file param' do
        it { expect(medium.modified_attachment_url(raw_file: true)).to include('https://test.com/rails/active_storage/blobs/redirect') }
      end
    end
  end
end
