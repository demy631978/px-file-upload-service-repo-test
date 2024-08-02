# frozen_string_literal: true

class Px::Medium::PatchService < BaseService
  object :medium

  anything :modified_metadata,
           :modified_attachment, default: nil
  string :file_name,
         :label,
         :duration,
         :modified_duration,
         :tag_list, default: nil
  boolean :visible, :media_bin, default: nil

  validates :file_name, presence: true, unless: -> { file_name.nil? }

  def execute # rubocop:disable Metrics/PerceivedComplexity
    medium.modified_attachment = modified_attachment unless modified_attachment.nil?
    medium.modified_metadata = modified_metadata_parse unless modified_metadata.nil?
    medium.file_name = file_name unless file_name.nil?
    medium.tag_list = tag_list unless tag_list.nil?
    medium.visible = visible unless visible.nil?
    medium.media_bin = media_bin unless media_bin.nil?
    medium.duration = duration unless duration.nil?
    medium.label = label unless label.nil?
    medium.modified_duration = modified_duration unless modified_duration.nil?

    medium.save
    MediumSerializer.new(medium)
  end

  private

  def modified_metadata_parse
    return modified_metadata if modified_metadata.is_a?(Hash)

    JSON.parse(modified_metadata)
  end
end
