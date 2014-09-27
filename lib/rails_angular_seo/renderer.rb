require 'phantomjs'

module RailsAngularSeo
  class Renderer

    def self.render(env, seo_id, server_name)
      path = "#{env["rack.url_scheme"]}://#{server_name}#{env["REQUEST_PATH"]}"
      output = ""
      Phantomjs.run(File.expand_path("../../../phantomjs/phantomjs-runner.js", __FILE__), path, seo_id) {|line| output += line}
      [200, { "Content-Type" => "text/html" }, [output]]
    end
  end
end