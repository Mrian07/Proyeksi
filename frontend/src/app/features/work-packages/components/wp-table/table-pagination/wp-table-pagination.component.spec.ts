

import { HttpClientModule } from '@angular/common/http';
import { IsolatedQuerySpace } from 'core-app/features/work-packages/directives/query-space/isolated-query-space';
import { inject, TestBed, waitForAsync } from '@angular/core/testing';
import { States } from 'core-app/core/states/states.service';
import { WorkPackageViewPaginationService } from 'core-app/features/work-packages/routing/wp-view-base/view-services/wp-view-pagination.service';
import { WorkPackageTablePaginationComponent } from 'core-app/features/work-packages/components/wp-table/table-pagination/wp-table-pagination.component';
import { PathHelperService } from 'core-app/core/path-helper/path-helper.service';
import { I18nService } from 'core-app/core/i18n/i18n.service';
import { OpenProject } from 'core-app/core/setup/globals/openproject';
import { WorkPackageViewSortByService } from 'core-app/features/work-packages/routing/wp-view-base/view-services/wp-view-sort-by.service';
import { ConfigurationService } from 'core-app/core/config/configuration.service';
import { OpIconComponent } from 'core-app/shared/components/icon/icon.component';
import { IPaginationOptions, PaginationService } from 'core-app/shared/components/table-pagination/pagination-service';
import { PaginationInstance } from 'core-app/shared/components/table-pagination/pagination-instance';
import { HalResourceService } from 'core-app/features/hal/services/hal-resource.service';

function setupMocks(paginationService:PaginationService) {
  const options:IPaginationOptions = {
    perPage: 0,
    perPageOptions: [10, 50],
    maxVisiblePageOptions: 1,
    optionsTruncationSize: 6,
  };

  spyOn(paginationService, 'getMaxVisiblePageOptions').and.callFake(() => options.maxVisiblePageOptions);

  spyOn(paginationService, 'getOptionsTruncationSize').and.callFake(() => options.optionsTruncationSize);

  spyOn(paginationService, 'loadPaginationOptions').and.callFake(() => Promise.resolve(options));
}

function pageString(element:JQuery) {
  return element.find('.op-pagination--range').text().trim();
}

describe('wpTablePagination Directive', () => {
  beforeEach(waitForAsync(() => {
    window.OpenProject = new OpenProject();

    // noinspection JSIgnoredPromiseFromCall
    TestBed.configureTestingModule({
      imports: [
        HttpClientModule,
      ],
      declarations: [
        WorkPackageTablePaginationComponent,
        OpIconComponent,
      ],
      providers: [
        States,
        PaginationService,
        WorkPackageViewSortByService,
        PathHelperService,
        WorkPackageViewPaginationService,
        HalResourceService,
        ConfigurationService,
        IsolatedQuerySpace,
        I18nService,
      ],
    }).compileComponents();
  }));

  describe('page ranges and links', () => {
    it('should display the correct page range',
      inject([PaginationService], (paginationService:PaginationService) => {
        setupMocks(paginationService);
        const fixture = TestBed.createComponent(WorkPackageTablePaginationComponent);
        const app:WorkPackageTablePaginationComponent = fixture.debugElement.componentInstance;
        const element = jQuery(fixture.elementRef.nativeElement);

        app.pagination = new PaginationInstance(1, 0, 10);
        app.update();
        fixture.detectChanges();
        expect(pageString(element)).toEqual('');

        app.pagination = new PaginationInstance(1, 11, 10);
        app.update();
        fixture.detectChanges();
        expect(pageString(element)).toEqual('(1 - 10/11)');
      }));

    describe('"next" link', () => {
      it('hidden on the last page',
        inject([PaginationService], (paginationService:PaginationService) => {
          setupMocks(paginationService);
          const fixture = TestBed.createComponent(WorkPackageTablePaginationComponent);
          const app:WorkPackageTablePaginationComponent = fixture.debugElement.componentInstance;
          const element = jQuery(fixture.elementRef.nativeElement);

          app.pagination = new PaginationInstance(2, 11, 10);
          app.update();
          fixture.detectChanges();

          const liWithNextLink = element.find('.op-pagination--item-link_next').parent('li');
          const attrHidden = liWithNextLink.attr('hidden');
          expect(attrHidden).toBeDefined();
        }));
    });

    it('should display correct number of page number links',
      inject([PaginationService], (paginationService:PaginationService) => {
        setupMocks(paginationService);
        const fixture = TestBed.createComponent(WorkPackageTablePaginationComponent);
        const app:WorkPackageTablePaginationComponent = fixture.debugElement.componentInstance;
        const element = jQuery(fixture.elementRef.nativeElement);

        function numberOfPageNumberLinks() {
          return element.find('button[rel="next"]').length;
        }

        app.pagination = new PaginationInstance(1, 1, 10);
        app.update();
        fixture.detectChanges();
        expect(numberOfPageNumberLinks()).toEqual(1);

        app.pagination = new PaginationInstance(1, 11, 10);
        app.update();
        fixture.detectChanges();
        expect(numberOfPageNumberLinks()).toEqual(2);

        app.pagination = new PaginationInstance(1, 59, 10);
        app.update();
        fixture.detectChanges();
        expect(numberOfPageNumberLinks()).toEqual(6);
      }));
  });
});
