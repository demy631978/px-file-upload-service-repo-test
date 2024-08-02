# frozen_string_literal: true

class ImageThumbnailResizerJob < ApplicationJob
  queue_as :default

  THUMNAIL_DIMENSION = '0x320'

  def perform(medium_id)
    medium = Medium.find(medium_id)
    outcome = Px::Medium::ShowService.run(medium: medium, dimension: THUMNAIL_DIMENSION)
    return unless outcome.valid?

    Faraday.get(outcome.result)
  end
end
