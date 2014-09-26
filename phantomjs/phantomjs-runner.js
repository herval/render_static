var system = require('system');
var url = system.args[1] || '';

if(url.length > 0) {
  var page = require('webpage').create();
  page.viewportSize = {
    width: 1280,
    height: 960
  };
  page.open(url, function (status) {
    if (status == 'success') {
      var delay, checker = (function() {
        var status_element_id = system.args[2] || '';
        var html = page.evaluate(function (status_element_id) {
          var body;
          if(status_element_id == "")
          {  body = document.getElementsByTagName('body')[0];}
          else
          {  body = document.getElementById(status_element_id);}
          if(body.getAttribute('data-status') == 'ready') {
            return document.getElementsByTagName('html')[0].outerHTML;
          }
        }, status_element_id);
        if(html) {
          clearTimeout(delay);
          console.log(html);
          phantom.exit();
        }
      });
      delay = setInterval(checker, 100);
    }
  });
}