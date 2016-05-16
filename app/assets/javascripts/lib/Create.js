var Polldozer = Polldozer || {}; Polldozer["Create"] =
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

	var template = __webpack_require__(1);

	var lang = {
	  de: {
	    title: 'Stelle eine Frage…',
	    answerTitles: ['Auswahl 1', 'Auswahl 2', 'Auswahl 3 (optional)', 'Auswahl 4 (optional)', 'Auswahl 5 (optional)', 'Auswahl 6 (optional)', 'Auswahl 7 (optional)', 'Auswahl 8 (optional)'],
	    addChoice: '+ Auswahl hinzufügen',
	    lengthTitle: 'Dauer der Umfrage',
	    defaultLength: '1 Tag',
	    lengthDays: 'Tage',
	    lengthHours: 'Stunden',
	    lengthMinutes: 'Min',
	    success: 'Poll created',
	    submit: 'Umfrage hinzufügen'
	  },
	  en: {
	    title: 'Ask a question…',
	    answerTitles: ['Choice 1', 'Choice 2', 'Choice 3 (optional)', 'Choice 4 (optional)', 'Choice 5 (optional)', 'Choice 6 (optional)', 'Choice 7 (optional)', 'Choice 8 (optional)'],
	    addChoice: '+ Add a choice',
	    lengthTitle: 'Poll length',
	    defaultLength: '1 day',
	    lengthDays: 'Days',
	    lengthHours: 'Hours',
	    lengthMinutes: 'Min',
	    success: 'Poll created',
	    submit: 'Add Poll'
	  }
	};

	function getLang(locale) {
	  return lang[locale] || lang.en;
	}

	function removeClass(elem, className) {
	  elem.setAttribute('class', elem.getAttribute('class').replace(new RegExp(className, 'g'), ''));
	}

	function addClass(elem, className) {
	  elem.setAttribute('class', elem.getAttribute('class') + ' ' + className);
	}

	module.exports = function(options){
	  var element = options.element;
	  var langStrings = getLang(options.locale);
	  element.innerHTML = template(langStrings);
	  var errorsElem = element.querySelector('.poll-js-errors');
	  var selectDaysElem = element.querySelector('.poll-js-select-days');
	  var selectHoursElem = element.querySelector('.poll-js-select-hours');
	  var selectMinutesElem = element.querySelector('.poll-js-select-minutes');
	  var changeLengthButton = element.querySelector('.poll-js-change-length');
	  var addChoiceButton = element.querySelector('.poll-js-add-choice');

	  var showAdditionalChoiceFiled = function(e){
	    e.preventDefault();
	    var choiceElements = element.querySelectorAll('.poll-js-choice.poll-is-hide');
	    var choiceElem = choiceElements[0];
	    if (choiceElem) {
	      if (choiceElements.length === 1) {
	        addClass(addChoiceButton, 'poll-is-hide');
	      }
	      removeClass(choiceElem, 'poll-is-hide');

	      var removeChoiceButton = choiceElem.querySelector('.poll-js-remove-choice');
	      var removeChoiceFiled = function(){
	        addClass(choiceElem, 'poll-is-hide');
	        removeClass(addChoiceButton, 'poll-is-hide');

	        if (element.addEventListener) {
	          removeChoiceButton.removeEventListener('click', removeChoiceFiled);
	        }
	        else {
	          removeChoiceButton.detachEvent('onclick', removeChoiceFiled);
	        }
	      };
	      if (element.addEventListener) {
	        removeChoiceButton.addEventListener('click', removeChoiceFiled);
	      }
	      else {
	        removeChoiceButton.attachEvent('onclick', removeChoiceFiled);
	      }
	    }
	  };

	  var showLengthInputs = function(e){
	    e.preventDefault();
	    addClass(changeLengthButton, 'poll-is-hide');
	    removeClass(element.querySelector('.poll-js-lenght-inputs'), 'poll-is-hide');
	  };

	  var toggleDeactivtedMinutes = function(disable){
	    for (var i = 0; i < 5; i++) {
	      selectMinutesElem.children[i].disabled = disable;
	    }
	  };

	  var isMinutesValueTooLow = function() {
	    for (var i = 0; i < 5; i++) {
	      if (selectMinutesElem.value === i + '') {
	        return true;
	      }
	    }
	    return false;
	  };

	  var selectDaysChange = function(){
	    if (selectDaysElem.value === '0' && selectHoursElem.value === '0' && isMinutesValueTooLow()) {
	      selectHoursElem.selectedIndex = 1;
	    }
	    toggleDeactivtedMinutes(selectHoursElem.value === '0' && selectDaysElem.value === '0');
	  };
	  var selectHoursChange = function(){
	    if (selectHoursElem.value === '0' && selectDaysElem.value === '0' && isMinutesValueTooLow()) {
	      selectMinutesElem.selectedIndex = 5;
	    }
	    toggleDeactivtedMinutes(selectHoursElem.value === '0' && selectDaysElem.value === '0');
	  };

	  var submitPoll = function(e){
	    // TODO: remove `submit` event
	    e.preventDefault();
	    var answerTitles = [];
	    var answerInputs = element.querySelectorAll('.poll-js-answer-input');
	    for (var i = 0; i < 6; i++) {
	      if (answerInputs[i].value) {
	        answerTitles.push(answerInputs[i].value);
	      }
	    }
	    options.corsRequestFn({
	      onSuccess: function(data){
	        element.innerHTML = '<h3>' + langStrings.title + '</h3>';
	        options.onSuccess(data._id);
	      },
	      onFailure: function(xhrData){
	        if (xhrData && xhrData.responseJSON && xhrData.responseJSON.errors && xhrData.responseJSON.errors.length) {
	          removeClass(errorsElem, 'poll-is-hide');
	          errorsElem.innerHTML = xhrData.responseJSON.errors.join(', ');
	        }
	      }
	    }).post(options.apiUrl + 'api/v1/polls.json', {
	      poll_title: element.querySelector('.poll-js-title-input').value,
	      date: element.querySelector('.poll-js-select-minutes').value,
	      answer_titles: answerTitles
	    });
	    return false;
	  };

	  if (element.addEventListener) {
	    element.querySelector('form').addEventListener('submit', submitPoll, false);
	    selectDaysElem.addEventListener('change', selectDaysChange);
	    selectHoursElem.addEventListener('change', selectHoursChange);
	    changeLengthButton.addEventListener('click', showLengthInputs);
	    addChoiceButton.addEventListener('click', showAdditionalChoiceFiled);
	  }
	  else {
	    element.querySelector('form').attachEvent('onsubmit', submitPoll);
	    selectDaysElem.attachEvent('onchange', selectDaysChange);
	    selectHoursElem.attachEvent('onchange', selectHoursChange);
	    changeLengthButton.attachEvent('onclick', showLengthInputs);
	    addChoiceButton.attachEvent('onclick', showAdditionalChoiceFiled);
	  }
	};


/***/ },
/* 1 */
/***/ function(module, exports) {

	module.exports = function(poll) {
	  var _selectTag = function(name, maxLength, selectedIndex) {
	    var selectHtml = '<select class="poll-js-select-' + name + '" name="' + name + '">';
	    for (var i = 0; i < maxLength; i++) {
	      selectHtml += '<option value="' + i + '"';
	      if (i === selectedIndex) {
	        selectHtml += ' selected="true"';
	      }
	      selectHtml += '>' + i + '</option>';
	    }
	    return selectHtml + '</select>';
	  };

	  var hideAnswer = false;
	  var html = '<form>';
	  html += '<div class="poll-js-errors poll-errors poll-is-hide"></div>';
	  html += '<input class="poll-js-title-input" placeholder="' + poll.title + '" name="poll_title" required />';
	  html += '<ul>';
	  for (var i = 0; i < 8; i++) {
	    html += '<li class="poll-js-choice';
	    hideAnswer = i > 1;
	    if (hideAnswer) {
	      html += ' poll-is-hide';
	    }
	    html += '">';
	    html += '<input class="poll-js-answer-input" name="answer_titles[' + i + ']" placeholder="' + poll.answerTitles[i] + '"';
	    if ( ! hideAnswer) {
	      html += ' required';
	    }
	    html += ' />';
	    if (hideAnswer) {
	      html += '<a class="poll-js-remove-choice">&times;</a>';
	    }
	    html += '</li>';
	  }
	  html += '</ul>';
	  html += '<p><a href="#" class="poll-button poll-js-add-choice">' + poll.addChoice + '</a></p>';
	  html += '<p>' + poll.lengthTitle + ': <a class="poll-js-change-length" href="#">' + poll.defaultLength + '</a>';
	  html += '<span class="poll-js-lenght-inputs poll-is-hide">';
	  html += ' ' + poll.lengthDays + ': ' + _selectTag('days', 8, 1);
	  html += ' ' + poll.lengthHours + ': ' + _selectTag('hours', 24);
	  html += ' ' + poll.lengthMinutes + ': ' + _selectTag('minutes', 60);
	  html += '</span></p></ul><input class="poll-js-submit poll-button" type="submit" value=' + poll.submit + '></form>';
	  return html;
	};


/***/ }
/******/ ]);