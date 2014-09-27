= rails_angular_seo

* http://github.com/arunn/rails_angular_seo

== DESCRIPTION:

rails_angular_seo allows you to make your single-page apps (Backbone, Angular, etc) built on Rails SEO-friendly. It works by injecting a small rack middleware that will render pages as plain html, when the requester has one of the following user-agent headers:

Googlebot
Googlebot-Mobile
AdsBot-Google
Mozilla/5.0 (compatible; Ask Jeeves/Teoma; +http://about.ask.com/en/docs/about/webmasters.shtml)
Baiduspider
Mozilla/5.0 (compatible; bingbot/2.0; +http://www.bing.com/bingbot.htm)

Please note that, in order for this to work, you need more than one thread/process of your webserver running, as the middleware will effectively make a second call back to your own app and render the content, streaming it back to the requester (crawler/bot).


== TO DO/PROBLEMS:

* Caching support
* Support for other drivers
* Log what's going on

== INSTALL:

Add the following to your Gemfile:

    gem 'rails_angular_seo'

In order to serve a set of routes as a single-page app, your routes.rb usually contains a catch-all route that will direct /* or /something/* to the same index.html file (the root of your js app). In order to allow the rails_angular_seo middleware to intercept the right routes, you need to add this to your app initialization:

    config/initializers/rails_angular_seo.rb

    RailsAngularSeo::Middleware.base_path = "/" # replace / for whichever path matches your app's index.html
    RailsAngularSeo::Middleware.seo_id    = "seo_id" # replace seo_id with whatever ID is used for the HTML DOM element which would be updated with status as "ready" once the ajax load is completed.
    RailsAngularSeo::Middleware.server_name    = "NAME OF YOUR SERVER"

And you're done! The middleware will only try to static-render requests made by bots AND that would render application/html content.

You can test that everything is working as expected by CURLing:

    # this will render the usual blank slate client-side apps serve
    curl http://localhost:3000/some/backbone/route

    # this will render a static representation of your page (just like it would look like in a browser)
    curl -A "Googlebot" http://localhost:3000/some/backbone/route


