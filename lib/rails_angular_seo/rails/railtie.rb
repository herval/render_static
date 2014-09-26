require 'rails'

module RailsAngularSeo
  class Railtie < Rails::Railtie
    initializer "rails_angular_seo.insert_middleware" do |app|
      app.config.middleware.use RailsAngularSeo::Middleware
    end
  end
end
