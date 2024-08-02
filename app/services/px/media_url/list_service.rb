# frozen_string_literal: true

class Px::MediaUrl::ListService < BaseService
  array :ids

  def execute
    {
      data: media_links,
      message: 'Success'
    }
  end

  private

  def media_links
    return [] if media.nil?

    media.map { |medium| { id: medium.id, url: medium.modified_attachment_url || medium.attachment_url } }.compact
  end

  def media
    @media ||= Medium.where(id: ids)
  end
end
