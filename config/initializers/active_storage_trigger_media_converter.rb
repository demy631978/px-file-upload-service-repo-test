module ActiveStorageTriggerMediaConverter
  extend ActiveSupport::Concern

  prepended do
    after_commit :trigger_media_converter!, on: :create
  end

  def trigger_media_converter!
    MediaConverterJob.perform_later(record.id) if (record.audio? || record.video?) && !record.transcoded
  end
end

Rails.configuration.to_prepare do
  ActiveSupport.on_load(:active_storage_attachment) { prepend ActiveStorageTriggerMediaConverter }
end