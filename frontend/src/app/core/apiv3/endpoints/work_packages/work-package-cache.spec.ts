

import { Injector } from '@angular/core';
import { TestBed } from '@angular/core/testing';
import { I18nService } from 'core-app/core/i18n/i18n.service';
import { ToastService } from 'core-app/shared/components/toaster/toast.service';
import { PathHelperService } from 'core-app/core/path-helper/path-helper.service';
import { WorkPackageResource } from 'core-app/features/hal/resources/work-package-resource';
import { HalResourceService } from 'core-app/features/hal/services/hal-resource.service';
import { SchemaCacheService } from 'core-app/core/schemas/schema-cache.service';
import { States } from 'core-app/core/states/states.service';
import { take, takeWhile } from 'rxjs/operators';
import { WorkPackagesActivityService } from 'core-app/features/work-packages/components/wp-single-view-tabs/activity-panel/wp-activity.service';
import { ConfigurationService } from 'core-app/core/config/configuration.service';
import { WorkPackageNotificationService } from 'core-app/features/work-packages/services/notifications/work-package-notification.service';
import { WorkPackageCache } from 'core-app/core/apiv3/endpoints/work_packages/work-package.cache';
import { ProyeksiAppFileUploadService } from 'core-app/core/file-upload/op-file-upload.service';
import { ProyeksiAppDirectFileUploadService } from 'core-app/core/file-upload/op-direct-file-upload.service';
import { TimezoneService } from 'core-app/core/datetime/timezone.service';
import { HalResourceNotificationService } from 'core-app/features/hal/services/hal-resource-notification.service';
import { OpenprojectHalModule } from 'core-app/features/hal/openproject-hal.module';

describe('WorkPackageCache', () => {
  let injector:Injector;
  let states:States;
  let workPackageCache:WorkPackageCache;
  let schemaCacheService:SchemaCacheService;
  let dummyWorkPackages:WorkPackageResource[] = [];

  beforeEach(() => {
    TestBed.configureTestingModule({
      imports: [
        OpenprojectHalModule,
      ],
      providers: [
        States,
        HalResourceService,
        TimezoneService,
        WorkPackagesActivityService,
        SchemaCacheService,
        PathHelperService,
        { provide: ConfigurationService, useValue: {} },
        { provide: I18nService, useValue: { t: (...args:any[]) => 'translation' } },
        { provide: WorkPackageResource, useValue: {} },
        { provide: ToastService, useValue: {} },
        { provide: HalResourceNotificationService, useValue: { handleRawError: () => false } },
        { provide: WorkPackageNotificationService, useValue: {} },
        { provide: ProyeksiAppFileUploadService, useValue: {} },
        { provide: ProyeksiAppDirectFileUploadService, useValue: {} },
      ],
    });

    injector = TestBed.inject(Injector);
    states = TestBed.inject(States);
    schemaCacheService = TestBed.inject(SchemaCacheService);
    workPackageCache = new WorkPackageCache(injector, states.workPackages);

    // sinon.stub(schemaCacheService, 'ensureLoaded').returns(Promise.resolve(true));
    spyOn(schemaCacheService, 'ensureLoaded').and.returnValue(Promise.resolve(true as any));

    const workPackage1 = new WorkPackageResource(
      injector,
      {
        id: '1',
        _links: {
          self: '',
        },
      },
      true,
      (wp:WorkPackageResource) => undefined,
      'WorkPackage',
    );

    dummyWorkPackages = [workPackage1 as any];
  });

  it('returns a work package after the list has been initialized', (done:any) => {
    workPackageCache.state('1').values$()
      .pipe(
        take(1),
      )
      .subscribe((wp:WorkPackageResource) => {
        expect(wp.id!).toEqual('1');
        done();
      });

    workPackageCache.updateWorkPackageList(dummyWorkPackages);
  });

  it('should return/stream a work package every time it gets updated', (done:any) => {
    let count = 0;

    workPackageCache.state('1').values$()
      .pipe(
        takeWhile((wp) => count < 2),
      )
      .subscribe((wp:WorkPackageResource) => {
        expect(wp.id!).toEqual('1');

        count += 1;
        if (count === 2) {
          done();
        }
      });

    workPackageCache.updateWorkPackageList([dummyWorkPackages[0]], false);
    workPackageCache.updateWorkPackageList([dummyWorkPackages[0]], false);
    workPackageCache.updateWorkPackageList([dummyWorkPackages[0]], false);
  });
});
