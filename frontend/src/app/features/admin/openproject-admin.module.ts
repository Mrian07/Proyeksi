

import { NgModule } from '@angular/core';
import { OPSharedModule } from 'core-app/shared/shared.module';
import { DragulaModule } from 'ng2-dragula';
import { TypeFormAttributeGroupComponent } from 'core-app/features/admin/types/attribute-group.component';
import { TypeFormConfigurationComponent } from 'core-app/features/admin/types/type-form-configuration.component';
import { TypeFormQueryGroupComponent } from 'core-app/features/admin/types/query-group.component';
import { GroupEditInPlaceComponent } from 'core-app/features/admin/types/group-edit-in-place.component';
import { EditableQueryPropsComponent } from 'core-app/features/admin/editable-query-props/editable-query-props.component';

@NgModule({
  imports: [
    DragulaModule.forRoot(),
    OPSharedModule,
  ],
  providers: [
  ],
  declarations: [
    TypeFormAttributeGroupComponent,
    TypeFormQueryGroupComponent,
    TypeFormConfigurationComponent,
    GroupEditInPlaceComponent,
    EditableQueryPropsComponent,
  ],
})
export class OpenprojectAdminModule { }
