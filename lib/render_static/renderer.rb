require 'selenium-webdriver'
require 'phantomjs'

module RenderStatic
  class Renderer

    def self.render(env)
      path = "#{env["rack.url_scheme"]}://#{env["HTTP_HOST"]}#{env["REQUEST_PATH"]}"
      byebug
      Phantomjs.run('./phantomjs/phantomjs-runner.js', path)
    end
  end
end