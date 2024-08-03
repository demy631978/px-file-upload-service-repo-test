# frozen_string_literal: true

class Px::Medium::ListService < BaseService
  uuid :user_id
  string :file_type, default: nil
  boolean :media_bin, default: nil

  def execute
    MediumSerializer.new(media.order(created_at: :desc), options)
  end

  private

  def media
    @media ||= begin
      user_media = Medium.where(user_id: user_id)
      user_media = user_media.where(file_type: file_type) if file_type.present?
      user_media = user_media.where(media_bin: media_bin) unless media_bin.nil?
      user_media.with_attached_attachment.includes(:tags).order(created_at: :desc)
    end
  end

  def options
    return {} if file_type.blank?

    {
      meta: {
        tags: media.tags_on(:tags).pluck(:name),
        total: media.length
      }
    }
  end
end