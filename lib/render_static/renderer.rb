require 'selenium-webdriver'
require 'headless'

module RenderStatic
  class Renderer

    def self.render(env)
      Headless.ly do
        browser = Selenium::WebDriver.for(:firefox)
        path = "#{env["rack.url_scheme"]}://#{env["HTTP_HOST"]}#{env["REQUEST_PATH"]}"
        browser.navigate.to(path)
        [200, { "Content-Type" => "text/html" }, [browser.page_source]] # TODO status code not supported by selenium
      end
    end
  end
end