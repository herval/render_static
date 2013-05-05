require "render_static/renderer"

describe RenderStatic::Renderer do
  class Headless
    def self.ly &block
      yield
    end
  end

  describe ".render" do
    it "requests the content" do
      env = { "HTTP_HOST" => "localhost:3000", "REQUEST_PATH" => "/abc", "rack.url_scheme" => "https" }

      navigate = stub
      browser = stub(navigate: navigate, page_source: "loaded page")
      Selenium::WebDriver.should_receive(:for).with(:firefox) { browser }

      navigate.should_receive(:to).with("https://localhost:3000/abc")

      response = RenderStatic::Renderer.render(env)

      response[0].should == 200
      response[1].should == {"Content-Type"=>"text/html"}
      response[2].should == ["loaded page"]
    end
  end
end