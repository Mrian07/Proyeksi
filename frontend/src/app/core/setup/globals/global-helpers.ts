

/**
 * A set of global helpers that were used in the app/assets/javascript namespace
 * but exposed globally.
 *
 * It is used in some `link_to_function` helpers in Rails templates
 */
export class GlobalHelpers {
  public checkAll(selector:any, checked:any) {
    document
      .querySelectorAll(`#${selector} input[type="checkbox"]:not([disabled])`)
      .forEach((el:HTMLInputElement) => el.checked = checked);
  }

  public toggleCheckboxesBySelector(selector:any) {
    const boxes = jQuery(selector);
    let all_checked = true;
    for (let i = 0; i < boxes.length; i++) {
      if (boxes[i].checked === false) {
        all_checked = false;
      }
    }
    for (let i = 0; i < boxes.length; i++) {
      boxes[i].checked = !all_checked;
    }
  }
}
