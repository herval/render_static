require "RailsAngularSeo/renderer"

describe RailsAngularSeo::Renderer do

  describe ".render" do
    it "requests the content" do
      env = { "HTTP_HOST" => "localhost:3000", "REQUEST_PATH" => "/abc", "rack.url_scheme" => "https" }

      navigate = stub
      browser = stub(navigate: navigate, page_source: "loaded page")

      response = RailsAngularSeo::Renderer.render(env)

      response[0].should == 200
      response[1].should == {"Content-Type"=>"text/html"}
      response[2].should == ["loaded page"]
    end
  end
end