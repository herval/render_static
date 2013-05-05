require 'rails'

module RenderStatic
  class Railtie < Rails::Railtie
    initializer "render_static.insert_middleware" do |app|
      app.config.middleware.use RenderStatic::Middleware
    end
  end
end
