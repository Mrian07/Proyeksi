

import { Injectable, Injector } from '@angular/core';
import { BehaviorSubject } from 'rxjs';
import { I18nService } from 'core-app/core/i18n/i18n.service';
import { CurrentProjectService } from 'core-app/core/current-project/current-project.service';
import { DeviceService } from 'core-app/core/browser/device.service';
import { InjectField } from 'core-app/shared/helpers/angular/inject-field.decorator';

@Injectable({ providedIn: 'root' })
export class MainMenuToggleService {
  public toggleTitle:string;

  private elementWidth:number;

  private elementMinWidth = 11;

  private readonly defaultWidth:number = 230;

  private readonly localStorageKey:string = 'openProject-mainMenuWidth';

  private readonly localStorageStateKey:string = 'openProject-mainMenuCollapsed';

  @InjectField() currentProject:CurrentProjectService;

  private global = (window as any);

  private htmlNode = document.getElementsByTagName('html')[0];

  private mainMenu = jQuery('#main-menu')[0]; // main menu, containing sidebar and resizer

  private hideElements = jQuery('.can-hide-navigation');

  // Title needs to be sync in main-menu-toggle.component.ts and main-menu-resizer.component.ts
  private titleData = new BehaviorSubject<string>('');

  public titleData$ = this.titleData.asObservable();

  // Notes all changes of the menu size (currently needed in wp-resizer.component.ts)
  private changeData = new BehaviorSubject<any>({});

  public changeData$ = this.changeData.asObservable();

  constructor(protected I18n:I18nService,
    public injector:Injector,
    readonly deviceService:DeviceService) {
  }

  public initializeMenu():void {
    if (!this.mainMenu) {
      return;
    }

    this.elementWidth = parseInt(window.ProyeksiApp.guardedLocalStorage(this.localStorageKey) as string);
    const menuCollapsed = window.ProyeksiApp.guardedLocalStorage(this.localStorageStateKey) as string;

    if (!this.elementWidth) {
      this.saveWidth(this.mainMenu.offsetWidth);
    } else if (menuCollapsed && JSON.parse(menuCollapsed)) {
      this.closeMenu();
    } else {
      this.setWidth();
    }

    const currentProject:CurrentProjectService = this.injector.get(CurrentProjectService);
    if (jQuery(document.body).hasClass('controller-my') && this.elementWidth === 0 || currentProject.id === null) {
      this.saveWidth(this.defaultWidth);
    }

    // mobile version default: hide menu on initialization
    this.closeWhenOnMobile();
  }

  // click on arrow or hamburger icon
  public toggleNavigation(event?:JQuery.TriggeredEvent):void {
    if (event) {
      event.stopPropagation();
      event.preventDefault();
    }

    if (!this.showNavigation) { // sidebar is hidden -> show menu
      if (this.deviceService.isMobile) { // mobile version
        this.setWidth(window.innerWidth);
      } else { // desktop version
        const savedWidth = parseInt(window.ProyeksiApp.guardedLocalStorage(this.localStorageKey) as string);
        const widthToSave = savedWidth >= this.elementMinWidth ? savedWidth : this.defaultWidth;

        this.saveWidth(widthToSave);
      }
    } else { // sidebar is expanded -> close menu
      this.closeMenu();
    }

    // Set focus on first visible main menu item.
    // This needs to be called after AngularJS has rendered the menu, which happens some when after(!) we leave this
    // method here. So we need to set the focus after a timeout.
    setTimeout(() => {
      jQuery('#main-menu [class*="-menu-item"]:visible').first().focus();
    }, 500);
  }

  public closeMenu():void {
    this.setWidth(0);
    window.ProyeksiApp.guardedLocalStorage(this.localStorageStateKey, 'true');
    jQuery('.searchable-menu--search-input').blur();
  }

  public closeWhenOnMobile():void {
    if (this.deviceService.isMobile) {
      this.closeMenu();
      window.ProyeksiApp.guardedLocalStorage(this.localStorageStateKey, 'false');
    }
  }

  public saveWidth(width?:number):void {
    this.setWidth(width);
    window.ProyeksiApp.guardedLocalStorage(this.localStorageKey, String(this.elementWidth));
    window.ProyeksiApp.guardedLocalStorage(this.localStorageStateKey, String(this.elementWidth === 0));
  }

  public setWidth(width?:any):void {
    if (width !== undefined) {
      // Leave a minimum amount of space for space fot the content
      const maxMenuWidth = this.deviceService.isMobile ? window.innerWidth - 120 : window.innerWidth - 520;
      if (width > maxMenuWidth) {
        this.elementWidth = maxMenuWidth;
      } else {
        this.elementWidth = width as number;
      }
    }

    this.snapBack();
    this.setToggleTitle();
    this.toggleClassHidden();

    this.global.showNavigation = this.showNavigation;
    this.htmlNode.style.setProperty('--main-menu-width', `${this.elementWidth}px`);

    // Send change event when size of menu is changing (menu toggled or resized)
    const changeEvent = jQuery.Event('change');
    this.changeData.next(changeEvent);
  }

  public get showNavigation():boolean {
    return (this.elementWidth >= this.elementMinWidth);
  }

  private snapBack():void {
    if (this.elementWidth < this.elementMinWidth) {
      this.elementWidth = 0;
    }
  }

  private setToggleTitle():void {
    if (this.showNavigation) {
      this.toggleTitle = this.I18n.t('js.label_hide_project_menu');
    } else {
      this.toggleTitle = this.I18n.t('js.label_expand_project_menu');
    }
    this.titleData.next(this.toggleTitle);
  }

  private toggleClassHidden():void {
    this.hideElements.toggleClass('hidden-navigation', !this.showNavigation);
  }
}
