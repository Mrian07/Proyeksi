

/*
  The action menu is a menu that usually belongs to an OpenProject entity (like an Issue, WikiPage, Meeting, ..).
  Most likely it looks like this:
    <ul class="action_menu_main">
      <li><a>Menu item text</a></li>
      <li><a>Menu item text</a></li>
      <li class="drop-down">
        <a class="icon icon-more" href="#">More functions</a>
        <ul style="display:none;" class="menu-drop-down-container">
          <li><a>Menu item text</a></li>
        </ul>
      </li>
    </ul>
  The following code is responsible to open and close the "more functions" submenu.
*/
import { ANIMATION_RATE_MS } from 'core-app/core/setup/globals/global-listeners/top-menu';
import ClickEvent = JQuery.ClickEvent;

function closeMenu(event:any) {
  const menu = jQuery(event.data.menu);
  // do not close the menu, if the user accidentally clicked next to a menu item (but still within the menu)
  if (event.target !== menu.find(' > li.drop-down.open > ul').get(0)) {
    menu.find(' > li.drop-down.open').removeClass('open').find('> ul').slideUp(ANIMATION_RATE_MS);
    // no need to watch for clicks, when the menu is already closed
    jQuery('html').off('click', closeMenu);
  }
}

function openMenu(menu:JQuery) {
  const dropDown = menu.find(' > li.drop-down');
  // do not open a menu, which is already open
  if (!dropDown.hasClass('open')) {
    dropDown.find('> ul').slideDown(ANIMATION_RATE_MS, () => {
      dropDown.find('li > a:first').focus();
      // when clicking on something, which is not the menu, close the menu
      jQuery('html').on('click', { menu: menu.get(0) }, closeMenu);
    });
    dropDown.addClass('open');
  }
}

// open the given submenu when clicking on it
export function installMenuLogic(menu:JQuery) {
  menu.find(' > li.drop-down').on('click', (event:ClickEvent) => {
    openMenu(menu);
    // and prevent default action (href) for that element
    // but not for the menu items.
    const target = jQuery(event.target);
    if (target.is('.drop-down') || target.closest('li, ul').is('.drop-down')) {
      event.preventDefault();
    }
  });
}
