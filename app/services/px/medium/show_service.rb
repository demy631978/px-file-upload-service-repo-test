# frozen_string_literal: true

class Px::Medium::ShowService < BaseService
  object :medium

  string :dimension,
         :attachment, default: nil
  boolean :raw_file, default: false

  def execute
    return "#{attachment_url}/#{dimension}" if medium.image? && dimension.present?

    attachment_url
  end

  private

  def attachment_url
    return medium.attachment_url(raw_file: raw_file) if attachment == 'original'

    medium.modified_attachment_url(raw_file: raw_file) || medium.attachment_url(raw_file: raw_file)
  end
end