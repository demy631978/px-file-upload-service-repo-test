class MediumAttachment < ActiveResource::Base
  self.headers['Authorization'] = "Bearer #{ENV['GENERAL_SERVICE_API_KEY']}" # rubocop:disable Style/RedundantSelf
  self.site = ENV['GENERAL_REMOTE_SERVICES_URL']
end