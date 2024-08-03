class Medium < ApplicationRecord
  acts_as_taggable_on :tags

  enum file_type: {
    image: 'Image',
    audio: 'Audio',
    video: 'Video',
    document: 'Document'
  }

  has_one_attached :attachment
  has_one_attached :modified_attachment

  validates :file_type, inclusion: { in: file_types }
  validates :user_id, presence: { message: 'invalid UUID' }, on: :create # rubocop:disable Rails/I18nLocaleTexts
  validates :attachment, :file_name, :file_size, presence: true, on: :create
  validates :file_width, :file_height, presence: true, if: :image?, on: :create

  after_commit :trigger_image_thumbnail_resizer_job, if: :image?, on: :create

  def attachment_url(raw_file: false)
    file_attachment_url(attachment, raw_file)
  end

  def modified_attachment_url(raw_file: false)
    file_attachment_url(modified_attachment, raw_file)
  end

  private

  def file_attachment_url(file_attachment, raw_file) # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
    return nil unless file_attachment.attached?
    return Rails.application.routes.url_helpers.url_for(file_attachment.attachment) if Rails.env.test?
    return file_attachment.attachment.url unless Rails.env.production? && !document?

    file_url = if image? && !raw_file
                 "#{ENV['IMG_RESIZE_URL']}/#{file_attachment.key}"
               elsif !transcoded
                 if video? && (Time.zone.now > created_at.since(5.minutes))
                   "#{ENV['TRANSCODED_URL']}/#{file_attachment.key}.mp4"
                 elsif audio? && (Time.zone.now > created_at.since(5.minutes))
                   "#{ENV['TRANSCODED_URL']}/#{file_attachment.key}.mp3"
                 end
               end
    file_url || file_attachment.attachment.url
  end

  def trigger_image_thumbnail_resizer_job
    ImageThumbnailResizerJob.perform_later(id)
  end
end
