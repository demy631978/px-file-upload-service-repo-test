task trigger_image_thumbnail_resizer: :environment do
  Medium.image.find_each(batch_size: 50) do |medium|
    outcome = Px::Medium::ShowService.run(medium: medium, dimension: '0x320')
    next unless outcome.valid?

    Faraday.get(outcome.result)
  end
end
