

import { HalResource } from 'core-app/features/hal/resources/hal-resource';
import { Attachable } from 'core-app/features/hal/resources/mixins/attachable-mixin';
import { CallableHalLink } from 'core-app/features/hal/hal-link/hal-link';

export class HelpTextBaseResource extends HalResource {
  public attribute:string;

  public attributeCaption:string;

  public scope:string;

  public helpText:api.v3.Formattable;
}

export const HelpTextResource = Attachable(HelpTextBaseResource);

export interface HelpTextResource extends HelpTextBaseResource {
  editText?:CallableHalLink;
}
