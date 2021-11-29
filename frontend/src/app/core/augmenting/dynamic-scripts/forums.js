

(function($) {
  jQuery(function() {

    function quoteResult(result) {
      var reply = $("#reply"),
        subject = $("#reply_subject"),
        focusElement = jQuery("#reply #message-form");

      subject.val(result.subject);

      $('ckeditor-augmented-textarea op-ckeditor')
        .data('editor')
        .then(function(editor) {
          editor.setData(result.content);
        });

      reply.slideDown();

      $('#content-wrapper').animate({
        scrollTop: focusElement.offset().top
      }, 1000);
    }

    $('.boards--quote-button').click(function(evt) {
      var link = $(this);

      $.getJSON(link.attr('href'))
        .done(quoteResult);

      evt.preventDefault();
      return false;
    });
  });

}(jQuery));
