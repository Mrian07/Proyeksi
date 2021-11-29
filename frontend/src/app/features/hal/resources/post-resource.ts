

import { HalResource } from 'core-app/features/hal/resources/hal-resource';
import { Attachable } from 'core-app/features/hal/resources/mixins/attachable-mixin';

export interface PostResourceLinks {
  addAttachment(attachment:HalResource):Promise<any>;
}

class PostBaseResource extends HalResource {
  public $links:PostResourceLinks;

  private attachmentsBackend = false;
}

export const PostResource = Attachable(PostBaseResource);

export type PostResource = PostResourceLinks;
