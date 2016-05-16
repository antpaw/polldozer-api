//= require lib/Vote.js

var corsRequestFn = function(options) {
  var ajax = function(url, type, data) {
    return $.ajax({
      url: url,
      type: type,
      crossDomain: true,
      contentType: data ? 'application/json; charset=utf-8' : void 0,
      dataType: 'json',
      data: data ? JSON.stringify(data) : void 0,
      success: options.onSuccess,
      error: options.onFailure,
      complete: options.onComplete
    });
  };
  return {
    get: function(url) {
      return ajax(url, 'GET');
    },
    post: function(url, data) {
      return ajax(url, 'POST', data);
    }
  };
};

new Polldozer.Vote({
  element: document.getElementById('vote'),
  apiUrl: 'http://localhost:3000/',
  corsRequestFn: corsRequestFn,
  pollData: window.pollData
});
