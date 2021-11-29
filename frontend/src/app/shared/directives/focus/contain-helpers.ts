

/**
 * Return whether the target element is either the same as within, or contained within it.
 *
 * @param {Element} within
 * @param {Element} target
 * @returns {boolean}
 */
export function insideOrSelf(within:Element, target:Element):boolean {
  return within === target || within.contains(target);
}

/**
 * Execute the callback when the element is outside
 * @param {Element} within
 * @param {Function} callback
 */
export function whenOutside(within:Element, callback:() => void) {
  setTimeout(() => {
    if (!insideOrSelf(within, document.activeElement!)) {
      callback();
    }
  }, 20);
}
