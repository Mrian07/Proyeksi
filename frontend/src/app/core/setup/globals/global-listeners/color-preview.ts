

/**
 * Moved from app/assets/javascripts/colors.js
 *
 * Make this a component instead of modifying it the next time
 * this needs changes
 */
export function makeColorPreviews() {
  jQuery('.color--preview').each(function () {
    const preview = jQuery(this);
    let input:any;
    const target = preview.data('target');

    if (target) {
      input = jQuery(target);
    } else {
      input = preview.next('input');
    }

    if (input.length === 0) {
      return;
    }

    const func = function () {
      let previewColor = '';

      if (input.val() && input.val().length > 0) {
        previewColor = input.val();
      } else if (input.attr('placeholder')
        && input.attr('placeholder').length > 0) {
        previewColor = input.attr('placeholder');
      }

      preview.css('background-color', previewColor);
    };

    input.keyup(func).change(func).focus(func);
    func();
  });
}
