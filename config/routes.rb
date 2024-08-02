# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  scope :monitoring do
    Sidekiq::Web.use Rack::Auth::Basic do |username, password|
      ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(username), ::Digest::SHA256.hexdigest(ENV['SIDEKIQ_UI_USERNAME'])) &
        ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(password), ::Digest::SHA256.hexdigest(ENV['SIDEKIQ_UI_PASSWORD']))
    end

    mount Sidekiq::Web, at: '/sidekiq'
  end

  api_version(module: 'Api::V1', path: { value: 'v1' }, defaults: { format: 'json' }) do
    resources :ping, only: :index

    resource :media, only: :destroy

    get 'media/:id/:dimension', to: 'media#show'
    resources :media, only: %i[index create show update] do
      resources :public_direct_upload, controller: 'media/public_direct_upload', only: :create
    end
    resources :media_aggregates, only: :index
    resources :media_urls, only: :index

    post '/presigned_url', to: 'direct_upload#create'

    namespace :remote_services do
      resources :media, only: %i[show destroy]
    end

    namespace :redis do
      resource :tokens, only: :destroy
    end
  end

  match '*path' => 'errors#not_found', via: :all # rescue routing error
end
