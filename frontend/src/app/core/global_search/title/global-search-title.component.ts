
import {
  ChangeDetectorRef, Component, ElementRef, Injector, Input, OnDestroy,
} from '@angular/core';
import { distinctUntilChanged } from 'rxjs/operators';
import { combineLatest } from 'rxjs';
import { I18nService } from 'core-app/core/i18n/i18n.service';
import { GlobalSearchService } from 'core-app/core/global_search/services/global-search.service';
import { CurrentProjectService } from 'core-app/core/current-project/current-project.service';
import { InjectField } from 'core-app/shared/helpers/angular/inject-field.decorator';
import { UntilDestroyedMixin } from 'core-app/shared/helpers/angular/until-destroyed.mixin';

export const globalSearchTitleSelector = 'global-search-title';

@Component({
  selector: 'global-search-title',
  templateUrl: './global-search-title.component.html',
})
export class GlobalSearchTitleComponent extends UntilDestroyedMixin implements OnDestroy {
  @Input() public searchTerm:string;

  @Input() public project:string;

  @Input() public projectScope:string;

  @Input() public searchTitle:string;

  @InjectField() private currentProjectService:CurrentProjectService;

  public text:{ [key:string]:string } = {
    all_projects: this.I18n.t('js.global_search.title.all_projects'),
    project_and_subprojects: this.I18n.t('js.global_search.title.project_and_subprojects'),
    search_for: this.I18n.t('js.global_search.title.search_for'),
    in: this.I18n.t('js.label_in'),
  };

  constructor(readonly elementRef:ElementRef,
    readonly cdRef:ChangeDetectorRef,
    readonly globalSearchService:GlobalSearchService,
    readonly I18n:I18nService,
    readonly injector:Injector) {
    super();
  }

  ngOnInit() {
    // Listen on changes of search input value and project scope
    combineLatest([
      this.globalSearchService.searchTerm$,
      this.globalSearchService.projectScope$,
    ])
      .pipe(
        distinctUntilChanged(),
        this.untilDestroyed(),
      )
      .subscribe(([newSearchTerm, newProjectScope]) => {
        this.searchTerm = newSearchTerm;
        this.project = this.projectText(newProjectScope);
        this.searchTitle = `${this.text.search_for} ${this.searchTerm} ${this.project === '' ? '' : this.text.in} ${this.project}`;

        this.cdRef.detectChanges();
      });
  }

  private projectText(scope:string):string {
    const currentProjectName = this.currentProjectService.name ? this.currentProjectService.name : '';

    switch (scope) {
      case 'all':
        return this.text.all_projects;
        break;
      case 'current_project':
        return currentProjectName;
        break;
      case '':
        return `${currentProjectName} ${this.text.project_and_subprojects}`;
        break;
      default:
        return '';
    }
  }
}
