

import { NgModule } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { CommonModule } from '@angular/common';
import { OpenprojectAttachmentsModule } from 'core-app/shared/components/attachments/openproject-attachments.module';
import { OpenprojectModalModule } from 'core-app/shared/components/modal/modal.module';
import { CkeditorAugmentedTextareaComponent } from 'core-app/shared/components/editor/components/ckeditor-augmented-textarea/ckeditor-augmented-textarea.component';
import { OpCkeditorComponent } from 'core-app/shared/components/editor/components/ckeditor/op-ckeditor.component';
import { CKEditorSetupService } from 'core-app/shared/components/editor/components/ckeditor/ckeditor-setup.service';
import { CKEditorPreviewService } from 'core-app/shared/components/editor/components/ckeditor/ckeditor-preview.service';
import { EditorMacrosService } from 'core-app/shared/components/modals/editor/editor-macros.service';
import { WikiIncludePageMacroModalComponent } from 'core-app/shared/components/modals/editor/macro-wiki-include-page-modal/wiki-include-page-macro.modal';
import { ChildPagesMacroModalComponent } from 'core-app/shared/components/modals/editor/macro-child-pages-modal/child-pages-macro.modal';
import { CodeBlockMacroModalComponent } from 'core-app/shared/components/modals/editor/macro-code-block-modal/code-block-macro.modal';

@NgModule({
  imports: [
    FormsModule,
    CommonModule,
    OpenprojectAttachmentsModule,
    OpenprojectModalModule,
  ],
  providers: [
    // CKEditor
    EditorMacrosService,
    CKEditorSetupService,
    CKEditorPreviewService,
  ],
  exports: [
    CkeditorAugmentedTextareaComponent,
    OpCkeditorComponent,
  ],
  declarations: [
    // CKEditor and Macros
    CkeditorAugmentedTextareaComponent,
    OpCkeditorComponent,
    WikiIncludePageMacroModalComponent,
    CodeBlockMacroModalComponent,
    ChildPagesMacroModalComponent,
  ],
})
export class OpenprojectEditorModule {
}
