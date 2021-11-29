

import {
  ChangeDetectionStrategy,
  ChangeDetectorRef,
  Component,
  ElementRef,
  Injector,
  Input,
  OnInit,
} from '@angular/core';
import { I18nService } from 'core-app/core/i18n/i18n.service';
import { OpModalService } from 'core-app/shared/components/modal/modal.service';
import { AttributeHelpTextsService } from './attribute-help-text.service';
import { AttributeHelpTextModalComponent } from './attribute-help-text.modal';
import { DatasetInputs } from 'core-app/shared/components/dataset-inputs.decorator';

export const attributeHelpTextSelector = 'attribute-help-text';

@DatasetInputs
@Component({
  selector: attributeHelpTextSelector,
  changeDetection: ChangeDetectionStrategy.OnPush,
  templateUrl: './attribute-help-text.component.html',
})
export class AttributeHelpTextComponent implements OnInit {
  // Attribute to show help text for
  @Input() public attribute:string;

  @Input() public additionalLabel?:string;

  // Scope to search for
  @Input() public attributeScope:string;

  // Load single id entry if given
  @Input() public helpTextId?:string|number;

  public exists = false;

  readonly text = {
    open_dialog: this.I18n.t('js.help_texts.show_modal'),
    edit: this.I18n.t('js.button_edit'),
    close: this.I18n.t('js.button_close'),
  };

  constructor(
    readonly elementRef:ElementRef,
    protected attributeHelpTexts:AttributeHelpTextsService,
    protected opModalService:OpModalService,
    protected cdRef:ChangeDetectorRef,
    protected injector:Injector,
    protected I18n:I18nService,
  ) {
  }

  ngOnInit() {
    if (this.helpTextId) {
      this.exists = true;
    } else {
      // Need to load the promise to find out if the attribute exists
      this.load().then((resource) => {
        this.exists = !!resource;
        this.cdRef.detectChanges();
        return resource;
      });
    }
  }

  public handleClick(event:Event):void {
    this.load().then((resource) => {
      this.opModalService.show(AttributeHelpTextModalComponent, this.injector, { helpText: resource });
    });

    event.preventDefault();
  }

  private load() {
    if (this.helpTextId) {
      return this.attributeHelpTexts.requireById(this.helpTextId);
    }
    return this.attributeHelpTexts.require(this.attribute, this.attributeScope);
  }
}
