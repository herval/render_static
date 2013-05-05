require "render_static/middleware"

describe RenderStatic::Middleware do
  let(:app) { stub }
  let(:middleware) { RenderStatic::Middleware.new(app) }
  let(:request) {
    {
        "PATH_INFO" => "/somewhere/",
        "REQUEST_METHOD" => "GET"
    }
  }

  before do
    RenderStatic::Middleware.base_path = "/somewhere/"
  end

  describe "a non-bot user agent" do
    it "passes-through" do
      env = request.merge("HTTP_USER_AGENT" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_3) AppleWebKit/537.31 (KHTML, like Gecko) Chrome/26.0.1410.65 Safari/537.31")

      app.should_receive(:call).with(env)
      RenderStatic::Renderer.should_not_receive(:render)

      middleware.call(env)
    end
  end

  describe "a bot user agent" do
    it "does not render if path doesn't match" do
      env = request.merge("HTTP_USER_AGENT" => "Googlebot", "PATH_INFO" => "/somewhere_else/a.html")

      app.should_receive(:call).with(env)
      RenderStatic::Renderer.should_not_receive(:render)
      middleware.call(env)
    end

    it "requests the same url and renders it" do
      env = request.merge("HTTP_USER_AGENT" => "Googlebot", "PATH_INFO" => "/somewhere/index.html")

      app.should_not_receive(:call)
      RenderStatic::Renderer.should_receive(:render).with(env)
      middleware.call(env)
    end

    it "renders content without an explicit type" do
      env = request.merge("HTTP_USER_AGENT" => "Googlebot", "PATH_INFO" => "/somewhere/index")

      app.should_not_receive(:call)
      RenderStatic::Renderer.should_receive(:render).with(env)
      middleware.call(env)
    end

    it "only renders GETs" do
      env = request.merge("REQUEST_METHOD" => "POST", "PATH_INFO" => "/somewhere/index")

      app.should_receive(:call)
      RenderStatic::Renderer.should_not_receive(:render)
      middleware.call(env)
    end

    it "does not render non-html content" do
      env = request.merge("HTTP_USER_AGENT" => "Googlebot", "PATH_INFO" => "/somewhere/a.js")

      app.should_receive(:call).with(env)
      RenderStatic::Renderer.should_not_receive(:render)
      middleware.call(env)
    end
  end
end