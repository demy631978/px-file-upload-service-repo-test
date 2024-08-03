# frozen_string_literal: true

class Px::MediaAggregate::ListService < BaseService
  string :user_id

  def execute
    {
      data: {
        images_count: media_counter_group_by_file_type['image'] || 0,
        videos_count: media_counter_group_by_file_type['video'] || 0,
        audios_count: media_counter_group_by_file_type['audio'] || 0,
        documents_count: media_counter_group_by_file_type['document'] || 0,
        storage_size_used: compute_total_storage_size_used,
        images_limit: 'Unlimited',
        videos_limit: 'Unlimited',
        audios_limit: 'Unlimited',
        documents_limit: 'Unlimited',
        storage_size_limit: 'Unlimited'
      },
      message: 'Success'
    }
  end

  private

  def media_counter_group_by_file_type
    @media_counter_group_by_file_type ||= media.group(:file_type).count
  end

  def compute_total_storage_size_used
    ActiveStorage::Attachment.includes(:blob).where(record: media).distinct.sum(&:byte_size)
  end

  def media
    @media ||= Medium.where(user_id: user_id)
  end
end
