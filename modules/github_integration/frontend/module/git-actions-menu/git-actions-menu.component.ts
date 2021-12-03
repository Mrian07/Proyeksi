

import copy from 'copy-text-to-clipboard';
import { Component, Inject, Input } from '@angular/core';
import { GitActionsService } from '../git-actions/git-actions.service';
import { ISnippet } from "core-app/features/plugins/linked/proyeksiapp-github_integration/typings";
import { WorkPackageResource } from "core-app/features/hal/resources/work-package-resource";
import { OPContextMenuComponent } from "core-app/shared/components/op-context-menu/op-context-menu.component";
import {
  OpContextMenuLocalsMap,
  OpContextMenuLocalsToken,
} from "core-app/shared/components/op-context-menu/op-context-menu.types";
import { I18nService } from "core-app/core/i18n/i18n.service";


@Component({
  selector: 'op-git-actions-menu',
  templateUrl: './git-actions-menu.template.html',
  styleUrls: [
    './styles/git-actions-menu.sass'
  ]
})
export class GitActionsMenuComponent extends OPContextMenuComponent {
  @Input() public workPackage:WorkPackageResource;

  public text = {
    title: this.I18n.t('js.github_integration.tab_header.git_actions.title'),
    copyButtonHelpText: this.I18n.t('js.github_integration.tab_header.git_actions.copy_button_help'),
    copyResult: {
      success: this.I18n.t('js.github_integration.tab_header.git_actions.copy_success'),
      error: this.I18n.t('js.github_integration.tab_header.git_actions.copy_error')
    }
  };

  public lastCopyResult:string = this.text.copyResult.success;
  public showCopyResult:boolean = false;
  public copiedSnippetId:string = '';

  public snippets:ISnippet[] = [
    {
      id: 'branch',
      name: this.I18n.t('js.github_integration.tab_header.git_actions.branch_name'),
      textToCopy: () => this.gitActions.branchName(this.workPackage)
    },
    {
      id: 'message',
      name: this.I18n.t('js.github_integration.tab_header.git_actions.commit_message'),
      textToCopy: () => this.gitActions.commitMessage(this.workPackage)
    },
    {
      id: 'command',
      name: this.I18n.t('js.github_integration.tab_header.git_actions.cmd'),
      textToCopy: () => this.gitActions.gitCommand(this.workPackage)
    },
  ];

  constructor(@Inject(OpContextMenuLocalsToken)
              public locals:OpContextMenuLocalsMap,
              readonly I18n:I18nService,
              readonly gitActions:GitActionsService) {
    super(locals);
    this.workPackage = this.locals.workPackage;
  }

  public onCopyButtonClick(snippet:ISnippet):void {
    const success = copy(snippet.textToCopy());

    if (success) {
      this.lastCopyResult = this.text.copyResult.success;
    } else {
      this.lastCopyResult = this.text.copyResult.error;
    }
    this.copiedSnippetId = snippet.id;
    this.showCopyResult = true;
    window.setTimeout(() => {
      this.showCopyResult = false;
    }, 2000);
  }
}
