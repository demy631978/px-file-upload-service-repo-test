# frozen_string_literal: true

class DirectUploadService < BaseService
  EXPIRATION_TIME = 6.hours

  integer :byte_size
  string :checksum
  string :filename
  string :content_type

  validates :byte_size, :checksum, :filename, :content_type, presence: true

  def execute
    blob = create_blob
    response = signed_url(blob)
    response[:blob_signed_id] = blob.signed_id
    response
  end

  private

  def create_blob
    ActiveStorage::Blob.create_before_direct_upload!(
      byte_size: byte_size,
      checksum: checksum,
      filename: filename,
      content_type: content_type
    )
  end

  def signed_url(blob)
    response_signature(
      blob.service_url_for_direct_upload(expires_in: EXPIRATION_TIME),
      headers: blob.service_headers_for_direct_upload
    )
  end

  def response_signature(url, **params)
    {
      direct_upload: {
        url: url
      }.merge(params)
    }
  end
end