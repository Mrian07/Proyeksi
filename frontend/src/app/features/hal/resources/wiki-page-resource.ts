

import { HalResource } from 'core-app/features/hal/resources/hal-resource';
import { Attachable } from 'core-app/features/hal/resources/mixins/attachable-mixin';

export interface WikiPageResourceLinks {
  addAttachment(attachment:HalResource):Promise<any>;
}

class WikiPageBaseResource extends HalResource {
  public $links:WikiPageResourceLinks;

  private attachmentsBackend = false;
}

export const WikiPageResource = Attachable(WikiPageBaseResource);

export type WikiPageResource = HalResource;
