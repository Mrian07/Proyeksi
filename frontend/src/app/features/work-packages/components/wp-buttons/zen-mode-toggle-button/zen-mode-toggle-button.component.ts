

import { ChangeDetectionStrategy, ChangeDetectorRef, Component } from '@angular/core';
import { I18nService } from 'core-app/core/i18n/i18n.service';

import * as sfimport from 'screenfull';
import { Screenfull } from 'screenfull';
import { AbstractWorkPackageButtonComponent } from '../wp-buttons.module';

const screenfull:Screenfull = sfimport as any;
export const zenModeComponentSelector = 'zen-mode-toggle-button';

@Component({
  templateUrl: '../wp-button.template.html',
  changeDetection: ChangeDetectionStrategy.OnPush,
  selector: zenModeComponentSelector,
})
export class ZenModeButtonComponent extends AbstractWorkPackageButtonComponent {
  public buttonId = 'work-packages-zen-mode-toggle-button';

  public buttonClass = 'toolbar-icon';

  public iconClass = 'icon-zen-mode';

  static inZenMode = false;

  private activateLabel:string;

  private deactivateLabel:string;

  constructor(readonly I18n:I18nService,
    readonly cdRef:ChangeDetectorRef) {
    super(I18n);

    this.activateLabel = I18n.t('js.zen_mode.button_activate');
    this.deactivateLabel = I18n.t('js.zen_mode.button_deactivate');
    const self = this;

    if (screenfull.enabled) {
      screenfull.onchange(() => {
        // This event might get triggered several times for once leaving
        // fullscreen mode.
        if (!screenfull.isFullscreen) {
          self.deactivateZenMode();
        }
      });
    }
  }

  public get label():string {
    if (this.isActive) {
      return this.deactivateLabel;
    }
    return this.activateLabel;
  }

  public isToggle():boolean {
    return true;
  }

  private deactivateZenMode():void {
    this.isActive = ZenModeButtonComponent.inZenMode = false;
    jQuery('body').removeClass('zen-mode');
    this.disabled = false;
    if (screenfull.enabled && screenfull.isFullscreen) {
      screenfull.exit();
    }
    this.cdRef.detectChanges();
  }

  private activateZenMode() {
    this.isActive = ZenModeButtonComponent.inZenMode = true;
    jQuery('body').addClass('zen-mode');
    if (screenfull.enabled) {
      screenfull.request();
    }
    this.cdRef.detectChanges();
  }

  public performAction(evt:Event):false {
    if (ZenModeButtonComponent.inZenMode) {
      this.deactivateZenMode();
    } else {
      this.activateZenMode();
    }

    evt.preventDefault();
    return false;
  }
}
