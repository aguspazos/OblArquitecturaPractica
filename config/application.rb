require File.expand_path('../boot', __FILE__)

require 'rails/all'
require 'aws-sdk'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Workspace
  class Application < Rails::Application
    
    Rails.application.config.assets.precompile += ['shipments/shipment.js', 'shipments/shipment.css']
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
    #paperclip S3 
    config.paperclip_defaults = {
        storage: :s3,
        s3_region: "us-east-1",
        s3_credentials: {
          bucket: "user-images-ort",
          access_key_id: "AKIAJ3DBGNVFD2GVHPFA",
          secret_access_key: "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"
          }
        }
    
  end
end
