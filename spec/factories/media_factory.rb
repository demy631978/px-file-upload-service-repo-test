FactoryBot.define do
  factory :medium do
    user_id { SecureRandom.uuid }
    attachment { Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/image.png'), 'image/png') }
    file_type { 'image' }
    file_name { 'image.png' }
    file_size { 123.3 }
    file_width { 100 }
    file_height { 100 }
  end
end
