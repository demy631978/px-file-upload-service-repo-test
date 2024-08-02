# frozen_string_literal: true

require 'rails_helper'

describe MediaConvertService do
  let(:expected_result) { { status: 'SUBMITTED' } }
  let(:service) { described_class.run(medium: create(:medium)) }

  describe 'create media convert job' do
    it do
      allow_any_instance_of(Aws::MediaConvert::Client).to receive(:create_job).and_return(expected_result)
      expect(service.result).to eq expected_result
    end
  end
end
