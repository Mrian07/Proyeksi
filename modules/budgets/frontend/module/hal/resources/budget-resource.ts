

import { HalResource } from "core-app/features/hal/resources/hal-resource";
import { Attachable } from "core-app/features/hal/resources/mixins/attachable-mixin";

export interface BudgetResourceLinks {
    addAttachment(attachment:HalResource):Promise<any>;
}

class BudgetBaseResource extends HalResource {
    public $links:BudgetResourceLinks;
}

export const BudgetResource = Attachable(BudgetBaseResource);

export interface BudgetResource extends BudgetBaseResource, BudgetResourceLinks {
}
