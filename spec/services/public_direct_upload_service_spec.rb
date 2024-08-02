# frozen_string_literal: true

require 'rails_helper'

describe PublicDirectUploadService do
  context 'with valid params' do
    describe 'Video medium' do
      let(:medium) { create(:medium, transcoded: true, file_type: 'video') }

      context 'when content type is jpg' do
        it do
          response = described_class.run(medium: medium, content_type: 'jpg')
          expect(response.result).to include "https://#{ENV['AWS_PUBLIC_BUCKET']}.s3.us-west-1.amazonaws.com/#{medium.attachment.key}.0000001.jpg"
        end
      end

      context 'when content type is mp4' do
        it do
          response = described_class.run(medium: medium, content_type: 'mp4')
          expect(response.result).to include "https://#{ENV['AWS_PUBLIC_BUCKET']}.s3.us-west-1.amazonaws.com/#{medium.attachment.key}.mp4"
        end
      end

      context 'when content type is mp3' do
        it do
          response = described_class.run(medium: medium, content_type: 'mp3')
          expect(response.errors.full_messages).to include 'Video medium only available to jpg or mp4 content_type'
        end
      end
    end

    describe 'Audio medium' do
      let(:medium) { create(:medium, transcoded: true, file_type: 'audio') }

      context 'when content type is jpg' do
        it do
          response = described_class.run(medium: medium, content_type: 'jpg')
          expect(response.errors.full_messages).to include 'Audio medium only available to mp3 content_type'
        end
      end

      context 'when content type is mp4' do
        it do
          response = described_class.run(medium: medium, content_type: 'mp4')
          expect(response.errors.full_messages).to include 'Audio medium only available to mp3 content_type'
        end
      end

      context 'when content type is mp3' do
        it do
          response = described_class.run(medium: medium, content_type: 'mp3')
          expect(response.result).to include "https://#{ENV['AWS_PUBLIC_BUCKET']}.s3.us-west-1.amazonaws.com/#{medium.attachment.key}.mp3"
        end
      end
    end

    describe 'Image medium' do
      let(:medium) { create(:medium, transcoded: true, file_type: 'image') }

      it do
        response = described_class.run(medium: medium, content_type: 'jpg')
        expect(response.errors.full_messages).to include 'Allowed medium file_types are video and audio'
      end
    end

    describe 'Document medium' do
      let(:medium) { create(:medium, transcoded: true, file_type: 'document') }

      it do
        response = described_class.run(medium: medium, content_type: 'jpg')
        expect(response.errors.full_messages).to include 'Allowed medium file_types are video and audio'
      end
    end
  end

  context 'with invalid params' do
    it do
      response = described_class.run
      expect(response.errors.full_messages).to eq ['Medium is required', 'Content type is required']
    end
  end

  context 'when medium is not flagged as transcoded' do
    let(:medium) { create(:medium, file_type: 'video') }

    it do
      response = described_class.run(medium: medium, content_type: 'jpg')
      expect(response.errors.full_messages).to include 'Media is not flagged as transcoded'
    end
  end
end
