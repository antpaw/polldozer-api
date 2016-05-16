var Polldozer = Polldozer || {}; Polldozer["Vote"] =
/******/ (function(modules) { // webpackBootstrap
/******/ 	// The module cache
/******/ 	var installedModules = {};

/******/ 	// The require function
/******/ 	function __webpack_require__(moduleId) {

/******/ 		// Check if module is in cache
/******/ 		if(installedModules[moduleId])
/******/ 			return installedModules[moduleId].exports;

/******/ 		// Create a new module (and put it into the cache)
/******/ 		var module = installedModules[moduleId] = {
/******/ 			exports: {},
/******/ 			id: moduleId,
/******/ 			loaded: false
/******/ 		};

/******/ 		// Execute the module function
/******/ 		modules[moduleId].call(module.exports, module, module.exports, __webpack_require__);

/******/ 		// Flag the module as loaded
/******/ 		module.loaded = true;

/******/ 		// Return the exports of the module
/******/ 		return module.exports;
/******/ 	}


/******/ 	// expose the modules object (__webpack_modules__)
/******/ 	__webpack_require__.m = modules;

/******/ 	// expose the module cache
/******/ 	__webpack_require__.c = installedModules;

/******/ 	// __webpack_public_path__
/******/ 	__webpack_require__.p = "";

/******/ 	// Load entry module and return exports
/******/ 	return __webpack_require__(0);
/******/ })
/************************************************************************/
/******/ ([
/* 0 */
/***/ function(module, exports, __webpack_require__) {

	var templateVote = __webpack_require__(2);
	var templateStats = __webpack_require__(4);

	var lang = {
	  de: {
	    title: 'Stelle eine Frage…',
	    finalResult: 'Final result',
	    submit: 'Absenden'
	  },
	  en: {
	    finalResult: 'Final result',
	    submit: 'Vote',
	    votes_many: 'Votes',
	    votes_one: 'Vote'
	  }
	};

	function getLang(locale) {
	  return lang[locale] || lang.en;
	}

	module.exports = function(options){
	  var element = options.element;
	  var pollId = element.getAttribute('data-poll-id');

	  var renderForm = function(poll){
	    element.innerHTML = templateVote(poll, getLang(options.locale));
	    var submitVote = function(e){
	      // TODO: remove `submit` event
	      e.preventDefault();
	      var answerElems = element.querySelectorAll('.poll-js-answer');
	      var answerId;
	      for (var i = 0; i < answerElems.length; i++) {
	        if (answerElems[i].checked) {
	          answerId = answerElems[i].value;
	        }
	      }
	      if ( ! answerId) { return; }
	      options.corsRequestFn({
	        onSuccess: renderResult,
	        onFailure: function(xhrData){
	          if (xhrData && xhrData.responseJSON && xhrData.responseJSON.errors && xhrData.responseJSON.errors.length) {
	            element.innerHTML = '<ul class="poll-errors">' + xhrData.responseJSON.errors.join(', ') + '</h3>';
	          }
	        }
	      }).post(options.apiUrl + 'api/v1/polls/' + pollId + '/vote.json', {
	        answer_id: answerId
	      });
	      return false;
	    };
	    if (element.addEventListener) {
	      element.querySelector('form').addEventListener('submit', submitVote, false);
	    }
	    else {
	      element.querySelector('form').attachEvent('onsubmit', submitVote);
	    }
	  };

	  var renderResult = function(poll){
	    element.innerHTML = templateStats(poll);
	  };

	  var initWithData = function(poll){
	    if (poll.ip_has_voted || poll.finished) {
	      renderResult(poll);
	    }
	    else {
	      renderForm(poll);
	    }
	  };

	  if (options.pollData) {
	    initWithData(options.pollData);
	  }
	  else {
	    options.corsRequestFn({
	      onSuccess: initWithData
	    }).get(options.apiUrl + 'api/v1/polls/' + pollId + '.json');
	  }
	};


/***/ },
/* 1 */,
/* 2 */
/***/ function(module, exports, __webpack_require__) {

	var _ = __webpack_require__(3);

	module.exports = function(poll) {
	  var html = '<form>';
	  html += '<h3>' + _(poll.title) + '</h3>';
	  html += '<ul>';
	  for (var i = 0; i < poll.answers.length; i++) {
	    html += '<li>';
	    html += '<h5>' + _(poll.answers[i].title) + '</h5>';
	    html += '<input class="poll-js-answer" type="radio" name="answer_id" value="' + poll.answers[i]._id + '" />';
	    html += '</li>';
	  }
	  html += '</ul><input class="poll-js-submit" type="submit"></form>';
	  return html;
	};


/***/ },
/* 3 */
/***/ function(module, exports) {

	module.exports = function(html) {
	  if (typeof html !== 'string') { return ''; }
	  return html.replace(/&/g, '&amp;')
	      .replace(/>/g, '&gt;')
	      .replace(/</g, '&lt;')
	      .replace(/"/g, '&quot;')
	      .replace(/'/g, '&apos;');
	};


/***/ },
/* 4 */
/***/ function(module, exports, __webpack_require__) {

	var _ = __webpack_require__(3);

	module.exports = function(poll) {
	  var html = '<form>';
	  html += '<h3>' + _(poll.title) + '</h3>';
	  html += '<ul>';
	  for (var i = 0; i < poll.answers.length; i++) {
	    html += '<li>';
	    html += '<h5>' + _(poll.answers[i].title) + '</h5>';
	    html += '<p>count: ' + poll.answers[i].vote_count + '</p>';
	    html += '<p>total: ' + poll.answers[i].percent_total + '%</p>';
	    html += '</li>';
	  }
	  html += '</ul></form>';
	  return html;
	};


/***/ }
/******/ ]);