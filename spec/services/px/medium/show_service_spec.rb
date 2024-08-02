# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Px::Medium::ShowService do
  let(:medium) { create(:medium) }
  let(:response) { described_class.run(medium: medium, raw_file: true) }

  it { expect(response.result).to include 'https://test.com/rails/active_storage/blobs' }
end