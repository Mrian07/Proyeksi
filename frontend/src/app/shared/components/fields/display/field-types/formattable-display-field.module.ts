

import { DisplayField } from 'core-app/shared/components/fields/display/display-field.module';
import { ApplicationRef } from '@angular/core';
import { DynamicBootstrapper } from 'core-app/core/setup/globals/dynamic-bootstrapper';
import { InjectField } from 'core-app/shared/helpers/angular/inject-field.decorator';
import { ExpressionService } from 'core-app/core/expression/expression.service';

export class FormattableDisplayField extends DisplayField {
  @InjectField() readonly appRef:ApplicationRef;

  public render(element:HTMLElement, displayText:string, options:any = {}):void {
    const div = document.createElement('div');

    div.classList.add(
      'read-value--html',
      'highlight',
      'op-uc-container',
      'op-uc-container_reduced-headings',
      '-multiline',
    );
    if (options.rtl) {
      div.classList.add('-rtl');
    }

    div.innerHTML = displayText;

    element.innerHTML = '';
    element.appendChild(div);

    // Allow embeddable rendered content
    DynamicBootstrapper.bootstrapOptionalEmbeddable(this.appRef, div);
  }

  public get isFormattable():boolean {
    return true;
  }

  public get value() {
    if (!this.schema) {
      return null;
    }
    const element = this.resource[this.name];
    if (!(element && element.html)) {
      return '';
    }

    return this.unescape(element.html);
  }

  // Escape the given HTML string from the backend, which contains escaped Angular expressions.
  // Since formattable fields are only binded to but never evaluated, we can safely remove these expressions.
  protected unescape(html:string) {
    if (html) {
      return ExpressionService.unescape(html);
    }
    return '';
  }
}
