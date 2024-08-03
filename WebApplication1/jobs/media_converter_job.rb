# frozen_string_literal: true

class MediaConverterJob < ApplicationJob
  queue_as :default
  sidekiq_options retry: 10

  def perform(medium_id)
    medium = Medium.find(medium_id)
    MediaConvertService.run(medium: medium)
  end
end
