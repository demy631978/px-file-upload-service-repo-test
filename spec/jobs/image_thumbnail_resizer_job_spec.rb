# frozen_string_literal: true

require 'rails_helper'
ActiveJob::Base.queue_adapter = :test

RSpec.describe ImageThumbnailResizerJob, type: :job do
  let(:medium) { create(:medium) }
  let(:outcome) { instance_double(Px::Medium::ShowService, valid?: true, result: 'http://testing.com/thumbnail') }

  before { allow(Px::Medium::ShowService).to receive(:run).with(medium: medium, dimension: described_class::THUMNAIL_DIMENSION).and_return(outcome) }

  it 'sends a Faraday get request to the correct URL when the outcome is valid' do
    expect(Faraday).to receive(:get).with('http://testing.com/thumbnail')

    described_class.perform_now(medium.id)
  end

  it 'does not send a Faraday get request when the outcome is not valid' do
    allow(outcome).to receive(:valid?).and_return(false)
    expect(Faraday).not_to receive(:get)

    described_class.perform_now(medium.id)
  end
end