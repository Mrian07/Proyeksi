

// This resource exists solely for the purpose of uploading attachments via the
// WYSIWYIG editor.
import { HalResource } from "core-app/features/hal/resources/hal-resource";
import { Attachable } from "core-app/features/hal/resources/mixins/attachable-mixin";

export interface DocumentResourceLinks {
    addAttachment(attachment:HalResource):Promise<any>;
}

class DocumentBaseResource extends HalResource {
    public $links:DocumentResourceLinks;

    private attachmentsBackend = false;
}

export const DocumentResource = Attachable(DocumentBaseResource);

export type DocumentResource = DocumentBaseResource;
