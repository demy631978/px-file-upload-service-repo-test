# frozen_string_literal: true

class PublicDirectUploadService < BaseService
  object :medium
  string :content_type

  validates :content_type, inclusion: { in: %w[jpg mp4 mp3] }

  set_callback :validate, :after, -> { valid_meduim }
  set_callback :validate, :after, -> { valid_meduim_file_type_with_content_type }

  def execute
    obj = bucket.object(key)
    obj.presigned_url(:put, acl: 'public-read')
  end

  private

  def key
    "#{medium.attachment.key}.#{key_suffix}"
  end

  def key_suffix
    content_type == 'jpg' ? '0000001.jpg' : content_type
  end

  def bucket
    aws_s3.bucket(ENV['AWS_PUBLIC_BUCKET'])
  end

  def aws_s3
    Aws::S3::Resource.new(client: aws_s3_client)
  end

  def aws_s3_client
    Aws::S3::Client.new(
      region: ENV['AWS_REGION'],
      access_key_id: ENV['AWS_ACCESS_KEY_ID'],
      secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
    )
  end

  def valid_meduim
    if medium.image? || medium.document?
      errors.add(:base, 'Allowed medium file_types are video and audio')
    elsif !medium.transcoded
      errors.add(:media, 'is not flagged as transcoded')
    end
  end

  def valid_meduim_file_type_with_content_type
    if medium.video? && (content_type != 'jpg' && content_type != 'mp4')
      errors.add(:base, 'Video medium only available to jpg or mp4 content_type')
    elsif medium.audio? && content_type != 'mp3'
      errors.add(:base, 'Audio medium only available to mp3 content_type')
    end
  end
end