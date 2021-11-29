

import { OpModalService } from 'core-app/shared/components/modal/modal.service';
import { Injectable, Injector } from '@angular/core';
import { WpButtonMacroModalComponent } from 'core-app/shared/components/modals/editor/macro-wp-button-modal/wp-button-macro.modal';
import { WikiIncludePageMacroModalComponent } from 'core-app/shared/components/modals/editor/macro-wiki-include-page-modal/wiki-include-page-macro.modal';
import { CodeBlockMacroModalComponent } from 'core-app/shared/components/modals/editor/macro-code-block-modal/code-block-macro.modal';
import { ChildPagesMacroModalComponent } from 'core-app/shared/components/modals/editor/macro-child-pages-modal/child-pages-macro.modal';

@Injectable()
export class EditorMacrosService {
  constructor(readonly opModalService:OpModalService,
    readonly injector:Injector) {
  }

  /**
   * Show a modal to edit the work package button macro settings.
   * Used from within ckeditor-augmented-textarea.
   */
  public configureWorkPackageButton(typeName?:string, classes?:string):Promise<{ type:string, classes:string }> {
    return new Promise<{ type:string, classes:string }>((resolve, reject) => {
      const modal = this.opModalService.show(WpButtonMacroModalComponent, this.injector, { type: typeName, classes });
      modal.closingEvent.subscribe((modal:WpButtonMacroModalComponent) => {
        if (modal.changed) {
          resolve({ type: modal.type, classes: modal.classes });
        }
      });
    });
  }

  /**
   * Show a modal to edit the wiki include macro.
   * Used from within ckeditor-augmented-textarea.
   */
  public configureWikiPageInclude(page:string):Promise<string> {
    return new Promise<string>((resolve, _) => {
      const pageValue = page || '';
      const modal = this.opModalService.show(WikiIncludePageMacroModalComponent, this.injector, { page: pageValue });
      modal.closingEvent.subscribe((modal:WikiIncludePageMacroModalComponent) => {
        if (modal.changed) {
          resolve(modal.page);
        }
      });
    });
  }

  /**
   * Show a modal to show an enhanced code editor for editing code blocks.
   * Used from within ckeditor-augmented-textarea.
   */
  public editCodeBlock(content:string, languageClass:string):Promise<{ content:string, languageClass:string }> {
    return new Promise<{ content:string, languageClass:string }>((resolve, _) => {
      const modal = this.opModalService.show(CodeBlockMacroModalComponent, this.injector, { content, languageClass });
      modal.closingEvent.subscribe((modal:CodeBlockMacroModalComponent) => {
        if (modal.changed) {
          resolve({ languageClass: modal.languageClass, content: modal.content });
        }
      });
    });
  }

  /**
   * Show a modal to edit the child pages macro.
   * Used from within ckeditor-augmented-textarea.
   */
  public configureChildPages(page:string, includeParent:string):Promise<object> {
    return new Promise<object>((resolve, _) => {
      const modal = this.opModalService.show(ChildPagesMacroModalComponent, this.injector, { page, includeParent });
      modal.closingEvent.subscribe((modal:ChildPagesMacroModalComponent) => {
        if (modal.changed) {
          resolve({
            page: modal.page,
            includeParent: modal.includeParent,
          });
        }
      });
    });
  }
}
