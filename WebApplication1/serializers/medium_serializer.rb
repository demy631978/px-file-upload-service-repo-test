class MediumSerializer
  include JSONAPI::Serializer

  attributes :id,
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
             :label

  attribute :modified_metadata do |object|
    JSON.parse(object.modified_metadata)
  rescue
    object.modified_metadata
  end

  attribute :tag_list do |object|
    object.tags.pluck(:name)
  end
end
