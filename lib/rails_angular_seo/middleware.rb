require 'rails_angular_seo/rails/railtie' if defined?(Rails)
require 'rails_angular_seo/renderer'

module RailsAngularSeo
  class NotSeoFriendly < Exception
  end

  class Middleware
    class << self
      attr_accessor :base_path
      attr_accessor :seo_id
      attr_accessor :server_name
    end

    def initialize(app)
      @app = app
    end

    def call(env)
      if will_render?(env)
        self.class.server_name ||= env["HTTP_X_FORWARDED_HOST"]
        RailsAngularSeo::Renderer.render(env, self.class.seo_id, self.class.server_name)
      else
        @app.call(env)
      end
    end

    private

    def will_render?(env)
      is_bot?(env) && is_renderable?(env)
    end

    def is_bot?(env)
      [
          "Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)",
          "Googlebot/2.1 (+http://www.google.com/bot.html)",
          "compatible; Mediapartners-Google/2.1; +http://www.google.com/bot.html",
          "AdsBot-Google (+http://www.google.com/adsbot.html)",
          "Mediapartners-Google",
          "Mozilla/5.0 (compatible; bingbot/2.0; +http://www.bing.com/bingbot.htm)",
          "Mozilla/5.0 (compatible; bingbot/2.0 +http://www.bing.com/bingbot.htm)",
          "Baiduspider+(+http://www.baidu.com/search/spider_jp.html)",
          "Baiduspider+(+http://www.baidu.com/search/spider.htm)",
          "BaiDuSpider"
      ].include?(env["HTTP_USER_AGENT"])
    end

    def is_renderable?(env)
      path = env["PATH_INFO"]
      content_type = path.index(".") && path.split(".").last

      path.start_with?(self.class.base_path) & [nil, "htm", "html"].include?(content_type) && env["REQUEST_METHOD"] == "GET"
    end
  end
end
