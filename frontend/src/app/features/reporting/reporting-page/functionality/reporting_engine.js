

/*jslint white: false, nomen: true, devel: true, on: true, debug: false, evil: true, onevar: false, browser: true, white: false, indent: 2 */
/*global window, $, $$, Reporting, Element */

window.Reporting = (function($) {
  var onload = function (func) {
    $(document).ready(func);
  };

  var flash = function (string, type) {
    if (!type) {
      type = "error";
    }

    var options = {};

    if (type === 'error') {
      options = {
        id: 'errorExplanation',
        class: 'errorExplanation'
      };
    }
    else {
      options = {
        id: 'flash_' + type,
        class: 'flash ' + type
      };
    }

    $("#" + options.id).remove();

    var flash = $('<div></div>')
      .attr('id', options.id)
      .attr('class', options.class)
      .attr('tabindex', 0)
      .attr('role', 'alert')
      .html(string);

    $('#content').prepend(flash);
    $('#' + options.id).focus();
  };

  var clearFlash = function () {
    $('div[id^=flash]').remove();
  };

  var fireEvent = function (element, event) {
    var evt;
    if (document.createEventObject) {
      // dispatch for IE
      evt = document.createEventObject();
      return element.fireEvent('on' + event, evt);
    } else {
      // dispatch for firefox + others
      evt = document.createEvent("HTMLEvents");
      evt.initEvent(event, true, true); // event type,bubbling,cancelable
      return !element.dispatchEvent(evt);
    }
  };

  return {
    fireEvent: fireEvent,
    clearFlash: clearFlash,
    flash: flash,
    onload: onload
  };
})(jQuery);
