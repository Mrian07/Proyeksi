import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ProyeksiappModalModule } from 'core-app/shared/components/modal/modal.module';
import { ProyeksiappAttachmentsModule } from 'core-app/shared/components/attachments/proyeksiapp-attachments.module';
import { IconModule } from 'core-app/shared/components/icon/icon.module';

import { AttributeHelpTextComponent } from './attribute-help-text.component';
import { AttributeHelpTextModalComponent } from './attribute-help-text.modal';

@NgModule({
  imports: [
    CommonModule,
    ProyeksiappModalModule,
    ProyeksiappAttachmentsModule,
    IconModule,
  ],
  declarations: [
    AttributeHelpTextComponent,
    AttributeHelpTextModalComponent,
  ],
  providers: [
  ],
  exports: [
    AttributeHelpTextComponent,
  ],
})
export class AttributeHelpTextModule {}
