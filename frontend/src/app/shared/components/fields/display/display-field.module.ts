

import { Field, IFieldSchema } from 'core-app/shared/components/fields/field.base';
import { I18nService } from 'core-app/core/i18n/i18n.service';
import { DisplayFieldContext } from 'core-app/shared/components/fields/display/display-field.service';
import { ResourceChangeset } from 'core-app/shared/components/fields/changeset/resource-changeset';
import { HalResource } from 'core-app/features/hal/resources/hal-resource';
import { InjectField } from 'core-app/shared/helpers/angular/inject-field.decorator';

export const cssClassCustomOption = 'custom-option';

export class DisplayField<T extends HalResource = HalResource> extends Field {
  public static type:string;

  public mode:string | null = null;

  public activeChange:ResourceChangeset<T>|null = null;

  @InjectField() I18n!:I18nService;

  constructor(public name:string, public context:DisplayFieldContext) {
    super();
  }

  /**
   * Apply the display field to the given resource and schema
   * @param resource
   * @param schema
   */
  public apply(resource:T, schema:IFieldSchema) {
    this.resource = resource;
    this.schema = schema;
  }

  public texts = {
    empty: this.I18n.t('js.label_no_value'),
    placeholder: this.I18n.t('js.placeholders.default'),
  };

  public get isFormattable():boolean {
    return false;
  }

  /**
   * Return the provided local injector,
   * which is relevant to provide the display field
   * the current space context.
   */
  public get injector() {
    return this.context.injector;
  }

  public get value() {
    if (!this.schema) {
      return null;
    }

    if (this.activeChange) {
      return this.activeChange.projectedResource[this.name];
    }
    return this.attribute;
  }

  protected get attribute() {
    return this.resource[this.name];
  }

  public get type():string {
    return (this.constructor as typeof DisplayField).type;
  }

  public get valueString():string {
    return this.value;
  }

  public get placeholder():string {
    return '-';
  }

  public get label() {
    return (this.schema.name || this.name);
  }

  public get title():string|null {
    // Don't return a value for long text fields,
    // since they shouldn't / won't be truncated.
    if (this.isFormattable) {
      return null;
    }

    return this.valueString;
  }

  public render(element:HTMLElement, displayText:string, options:any = {}):void {
    element.textContent = displayText;
  }

  /**
   * Render an empty placeholder if no values are present
   */
  public renderEmpty(element:HTMLElement) {
    const emptyDiv = document.createElement('div');
    emptyDiv.setAttribute('title', this.texts.empty);
    emptyDiv.textContent = this.texts.placeholder;
    emptyDiv.classList.add(cssClassCustomOption, '-empty');

    element.appendChild(emptyDiv);
  }
}
