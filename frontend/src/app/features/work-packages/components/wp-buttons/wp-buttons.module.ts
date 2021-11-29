

import { I18nService } from 'core-app/core/i18n/i18n.service';
import { UntilDestroyedMixin } from 'core-app/shared/helpers/angular/until-destroyed.mixin';

export interface ButtonControllerText {
  activate:string;
  deactivate:string;
  label:string;
  buttonText:string;
}

export abstract class AbstractWorkPackageButtonComponent extends UntilDestroyedMixin {
  public disabled:boolean;

  public buttonId:string;

  public iconClass:string;

  public accessKey:number;

  public isActive = false;

  protected text:ButtonControllerText;

  constructor(public I18n:I18nService) {
    super();

    this.text = {
      activate: this.I18n.t('js.label_activate'),
      deactivate: this.I18n.t('js.label_deactivate'),
      label: this.labelKey ? this.I18n.t(this.labelKey) : '',
      buttonText: this.textKey ? this.I18n.t(this.textKey) : '',
    };
  }

  public get label():string {
    return this.text.label;
  }

  public get buttonText():string {
    return this.text.buttonText;
  }

  public get labelKey():string {
    return '';
  }

  public get textKey():string {
    return '';
  }

  protected get activationPrefix():string {
    return !this.isActive ? `${this.text.activate} ` : '';
  }

  protected get deactivationPrefix():string {
    return this.isActive ? `${this.text.deactivate} ` : '';
  }

  protected get prefix():string {
    return this.activationPrefix || this.deactivationPrefix;
  }

  public isToggle():boolean {
    return false;
  }

  public abstract performAction(event:Event):void;
}
