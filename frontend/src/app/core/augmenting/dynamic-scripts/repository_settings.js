

jQuery(function($){
  var toggleContent = function(content,selected) {
    var vendor = $('#scm_vendor').val(),
      targetName = '#' + vendor + '-' + selected,
      oldTargets = content.find('.attributes-group').not(targetName);
    var newTarget  = jQuery(targetName);

    // would work with fieldset#disabled, but that's bugged up unto IE11
    // https://connect.microsoft.com/IE/feedbackdetail/view/962368/
    //
    // Ugly workaround: disable all inputs manually, but
    // spare enabling inputs marked with `aria-disabled`
    oldTargets
      .find('input,select')
      .prop('disabled', true);
    oldTargets.hide();

    newTarget
      .find('input,select')
      .not('[aria-disabled="true"]')
      .prop('disabled', false);
    newTarget.show();
  };

  // Submit form when
  $('.repositories--remote-select').change(function() {
    var select = $(this);
    var url = URI(select.data('url')).search({ scm_vendor: select.val() });

    window.location.href = url.toString();
  });

  $("[data-switch='scm_type']")
    .each(function(_i, el) {

      var fs = $(el),
        name = fs.attr('data-switch'),
        switches = fs.find('[name="' + name + '"]'),
        headers = fs.find('.attributes-group--header-text'),
        content = $(el);

      // Focus on first header
      headers.first().focus();

      // Open content if there is only one possible selection
      var checkedInput = jQuery('input[name=scm_type]:checked');
      if(checkedInput.length > 0) {
        toggleContent(content, checkedInput.val());
      }

      // Necessary for accessibilty purpose
      jQuery('#scm_vendor').on('change', function(){
        window.setTimeout(function(){
          document.getElementsByName('scm_type')[0].focus();
        }, 500);
      });

      // Toggle content
      switches.on('change', function() {
        toggleContent(content, this.value);
      });
    });
});
