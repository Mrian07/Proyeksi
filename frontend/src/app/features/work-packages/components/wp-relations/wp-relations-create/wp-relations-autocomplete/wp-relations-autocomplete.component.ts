

import {
  ChangeDetectorRef,
  Component,
  EventEmitter, HostListener,
  Input, NgZone,
  Output,
  ViewChild,
  ViewEncapsulation,
} from '@angular/core';
import { I18nService } from 'core-app/core/i18n/i18n.service';
import { WorkPackageResource } from 'core-app/features/hal/resources/work-package-resource';
import { from, Observable, of } from 'rxjs';
import { catchError, map, tap } from 'rxjs/operators';
import { IsolatedQuerySpace } from 'core-app/features/work-packages/directives/query-space/isolated-query-space';
import { PathHelperService } from 'core-app/core/path-helper/path-helper.service';
import { WorkPackageCollectionResource } from 'core-app/features/hal/resources/wp-collection-resource';
import { CurrentProjectService } from 'core-app/core/current-project/current-project.service';
import { HalResourceService } from 'core-app/features/hal/services/hal-resource.service';
import { SchemaCacheService } from 'core-app/core/schemas/schema-cache.service';
import { WorkPackageNotificationService } from 'core-app/features/work-packages/services/notifications/work-package-notification.service';
import { ApiV3Filter } from 'core-app/shared/helpers/api-v3/api-v3-filter-builder';
import { OpAutocompleterComponent } from 'core-app/shared/components/autocompleter/op-autocompleter/op-autocompleter.component';
import { HalResource } from 'core-app/features/hal/resources/hal-resource';

@Component({
  selector: 'wp-relations-autocomplete',
  templateUrl: './wp-relations-autocomplete.html',

  // Allow styling the embedded ng-select
  encapsulation: ViewEncapsulation.None,
  styleUrls: ['./wp-relations-autocomplete.sass'],
})
export class WorkPackageRelationsAutocompleteComponent {
  readonly text = {
    placeholder: this.I18n.t('js.relations_autocomplete.placeholder'),
  };

  @Input() inputPlaceholder:string = this.text.placeholder;

  @Input() workPackage:WorkPackageResource;

  @Input() selectedRelationType:string;

  @Input() filterCandidatesFor:string;

  /** Do we take the current query filters into account? */
  @Input() additionalFilters:ApiV3Filter[] = [];

  @Input() hiddenOverflowContainer = 'body';

  @ViewChild(OpAutocompleterComponent, { static: true }) public ngSelectComponent:OpAutocompleterComponent;

  @Output() onCancel = new EventEmitter<undefined>();

  @Output() onSelected = new EventEmitter<WorkPackageResource>();

  @Output() onEmptySelected = new EventEmitter<undefined>();

  // Whether we're currently loading
  public isLoading = false;

  getAutocompleterData = (query:string|null):Observable<HalResource[]> => {
    // Return when the search string is empty
    if (query === null || query.length === 0) {
      this.isLoading = false;
      return of([]);
    }

    return from(
      this.workPackage.availableRelationCandidates.$link.$fetch({
        query,
        filters: JSON.stringify(this.additionalFilters),
        type: this.filterCandidatesFor || this.selectedRelationType,
      }) as Promise<WorkPackageCollectionResource>,
    )
      .pipe(
        map((collection) => collection.elements),
        catchError((error:unknown) => {
          this.notificationService.handleRawError(error);
          return of([]);
        }),
        tap(() => this.isLoading = false),
      );
  };

  public autocompleterOptions = {
    resource: 'work_packages',
    getOptionsFn: this.getAutocompleterData,
  };

  public appendToContainer = 'body';

  constructor(private readonly querySpace:IsolatedQuerySpace,
    private readonly pathHelper:PathHelperService,
    private readonly notificationService:WorkPackageNotificationService,
    private readonly CurrentProject:CurrentProjectService,
    private readonly halResourceService:HalResourceService,
    private readonly schemaCacheService:SchemaCacheService,
    private readonly cdRef:ChangeDetectorRef,
    private readonly ngZone:NgZone,
    private readonly I18n:I18nService) {
  }

  @HostListener('keydown.escape')
  public reset() {
    this.cancel();
  }

  cancel() {
    this.onCancel.emit();
  }

  public onWorkPackageSelected(workPackage?:WorkPackageResource) {
    if (workPackage) {
      this.schemaCacheService
        .ensureLoaded(workPackage)
        .then(() => {
          this.onSelected.emit(workPackage);
          this.ngSelectComponent.ngSelectInstance.close();
        });
    }
  }

  onOpen() {
    // Force reposition as a workaround for BUG
    // https://github.com/ng-select/ng-select/issues/1259
    this.ngZone.runOutsideAngular(() => {
      setTimeout(() => {
        this.ngSelectComponent.repositionDropdown();
        jQuery(this.hiddenOverflowContainer).one('scroll', () => {
          this.ngSelectComponent.closeSelect();
        });
      }, 25);
    });
  }
}
