# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MediumSerializer, type: :serializer do
  let(:record) { create(:medium) }
  let(:serialized) { described_class.new(record).serializable_hash.as_json }

  describe 'attributes' do
    it { expect(serialized['data']).to have_id(record.id) }
    it { expect(serialized['data']).to have_type(:medium) }

    it do
      expect(serialized['data']).to have_jsonapi_attributes(
        :id,
        :attachment_url,
        :modified_attachment_url,
        :file_type,
        :file_name,
        :file_size,
        :file_width,
        :file_height,
        :duration,
        :modified_duration,
        :transcoded,
        :visible,
        :media_bin,
        :modified_metadata,
        :tag_list,
        :label
      ).exactly
    end
  end
end
