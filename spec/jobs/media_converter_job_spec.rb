# frozen_string_literal: true

require 'rails_helper'
ActiveJob::Base.queue_adapter = :test

RSpec.describe MediaConverterJob, type: :job do
  describe '#perform' do
    let!(:medium) { create(:medium, file_type: 'video') }
    let(:timezone_name) { 'America/New_York' }

    it 'matches queue name' do
      expect(described_class).to have_been_enqueued.on_queue('default')

      described_class.perform_later(medium.id)
    end

    it 'calls MediaConvertService service' do
      expect(MediaConvertService).to receive(:run).with(medium: medium)

      described_class.perform_now(medium.id)
    end
  end
end
