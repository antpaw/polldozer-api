var $ = require('jquery');
var PollVote = require('polldozer/vote');
var Cookies = require('js-cookie');

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

new PollVote({
  element: document.getElementById('vote'),
  apiUrl: '/',
  corsRequestFn: corsRequestFn,
  onVote: function(poll) {
    Cookies.set('poll_' + poll._id, poll.vote_id, {expires: new Date(2147483647000)});
  },
  pollData: window.pollData
});
