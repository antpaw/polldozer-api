var $ = require('jquery');
var PollCreate = require('polldozer/create');

var corsRequestFn = function(options) {
  var ajax = function(url, type, data) {
    return $.ajax({
      url: url,
      type: type,
      crossDomain: true,
      contentType: data ? 'application/json; charset=utf-8' : undefined,
      dataType: 'json',
      data: data ? JSON.stringify(data) : undefined,
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

new PollCreate({
  element: document.getElementById('vote'),
  apiUrl: '/',
  corsRequestFn: corsRequestFn,
  onCreate: function(poll){
    window.location = '/polls/' + poll._id;
  }
});
