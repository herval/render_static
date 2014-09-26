require 'phantomjs'

module RailsAngularSeo
  class Renderer

    def self.render(env, seo_id)
      path = "#{env["rack.url_scheme"]}://#{env["HTTP_HOST"]}#{env["REQUEST_PATH"]}"
      output = Phantomjs.run(File.expand_path("../../phantomjs/phantomjs-runner.js", __FILE__), path, seo_id)
      [200, { "Content-Type" => "text/html" }, [output]]
    end
  end
end