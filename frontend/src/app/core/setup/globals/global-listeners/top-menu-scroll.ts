

// Scroll header on mobile in and out when user scrolls the container
export function scrollHeaderOnMobile() {
  const headerHeight = 55;
  let prevScrollPos = window.scrollY;

  window.addEventListener('scroll', () => {
    // Condition needed for safari browser to avoid negative positions
    const currentScrollPos = window.scrollY < 0 ? 0 : window.scrollY;
    // Only if sidebar is not opened or search bar is opened
    if (!(jQuery('#main').hasClass('hidden-navigation'))
        || jQuery('.op-app-header').hasClass('op-app-header_search-open')
        || Math.abs(currentScrollPos - prevScrollPos) <= headerHeight) { // to avoid flickering at the end of the page
      return;
    }

    if (prevScrollPos !== undefined && currentScrollPos !== undefined && (prevScrollPos > currentScrollPos)) {
      // Slide top menu in or out of viewport and change viewport height
      jQuery('#wrapper').removeClass('_header-scrolled');
    } else {
      jQuery('#wrapper').addClass('_header-scrolled');
    }
    prevScrollPos = currentScrollPos;
  });
}
