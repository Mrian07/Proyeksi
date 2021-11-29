
import { Component, Input, OnInit } from '@angular/core';
import { PathHelperService } from 'core-app/core/path-helper/path-helper.service';
import { I18nService } from 'core-app/core/i18n/i18n.service';
import { WorkPackageResource } from 'core-app/features/hal/resources/work-package-resource';
import { Highlighting } from 'core-app/features/work-packages/components/wp-fast-table/builders/highlighting/highlighting.functions';
import idFromLink from 'core-app/features/hal/helpers/id-from-link';

@Component({
  templateUrl: './subtasks-board-header.html',
  styleUrls: ['./subtasks-board-header.sass'],
  host: { class: 'title-container -small' },
})
export class SubtasksBoardHeaderComponent implements OnInit {
  @Input() public resource:WorkPackageResource;

  idFromLink = idFromLink;

  text = {
    workPackage: this.I18n.t('js.label_work_package_parent'),
  };

  typeHighlightingClass:string;

  constructor(readonly pathHelper:PathHelperService,
    readonly I18n:I18nService) {
  }

  ngOnInit() {
    this.typeHighlightingClass = Highlighting.inlineClass('type', this.resource.type.id!);
  }
}
