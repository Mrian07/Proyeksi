

import { HalResource } from 'core-app/features/hal/resources/hal-resource';
import { Attachable } from 'core-app/features/hal/resources/mixins/attachable-mixin';

export interface MeetingContentResourceLinks {
  addAttachment(attachment:HalResource):Promise<any>;
}

class MeetingContentBaseResource extends HalResource {
  public $links:MeetingContentResourceLinks;

  private attachmentsBackend = false;
}

export const MeetingContentResource = Attachable(MeetingContentBaseResource);

export type MeetingContentResource = HalResource;
