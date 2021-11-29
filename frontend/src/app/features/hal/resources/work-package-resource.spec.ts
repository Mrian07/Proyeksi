

import { TestBed, waitForAsync } from '@angular/core/testing';
import { HalResourceService } from 'core-app/features/hal/services/hal-resource.service';
import { Injector } from '@angular/core';
import { States } from 'core-app/core/states/states.service';
import { HalResourceNotificationService } from 'core-app/features/hal/services/hal-resource-notification.service';
import { SchemaCacheService } from 'core-app/core/schemas/schema-cache.service';
import { PathHelperService } from 'core-app/core/path-helper/path-helper.service';
import { LoadingIndicatorService } from 'core-app/core/loading-indicator/loading-indicator.service';
import { ConfigurationService } from 'core-app/core/config/configuration.service';
import { I18nService } from 'core-app/core/i18n/i18n.service';
import { StateService } from '@uirouter/core';
import { WorkPackageCreateService } from 'core-app/features/work-packages/components/wp-new/wp-create.service';
import { WorkPackageNotificationService } from 'core-app/features/work-packages/services/notifications/work-package-notification.service';
import { WorkPackagesActivityService } from 'core-app/features/work-packages/components/wp-single-view-tabs/activity-panel/wp-activity.service';
import { APIV3Service } from 'core-app/core/apiv3/api-v3.service';
import { OpenProjectFileUploadService } from 'core-app/core/file-upload/op-file-upload.service';
import { OpenProjectDirectFileUploadService } from 'core-app/core/file-upload/op-direct-file-upload.service';
import { TimezoneService } from 'core-app/core/datetime/timezone.service';
import { AttachmentCollectionResource } from 'core-app/features/hal/resources/attachment-collection-resource';
import { OpenprojectHalModule } from 'core-app/features/hal/openproject-hal.module';
import { WorkPackageResource } from 'core-app/features/hal/resources/work-package-resource';
import isNewResource from 'core-app/features/hal/helpers/is-new-resource';

describe('WorkPackage', () => {
  let halResourceService:HalResourceService;
  let injector:Injector;
  let halResourceNotification:HalResourceNotificationService;

  let source:any;
  let workPackage:WorkPackageResource;

  const createWorkPackage = () => {
    source = source || { id: 'new' };
    workPackage = halResourceService.createHalResourceOfType('WorkPackage', { ...source });
  };

  beforeEach(waitForAsync(() => {
    // noinspection JSIgnoredPromiseFromCall
    TestBed.configureTestingModule({
      imports: [
        OpenprojectHalModule,
      ],
      providers: [
        HalResourceService,
        States,
        TimezoneService,
        WorkPackagesActivityService,
        ConfigurationService,
        OpenProjectFileUploadService,
        OpenProjectDirectFileUploadService,
        LoadingIndicatorService,
        PathHelperService,
        I18nService,
        APIV3Service,
        { provide: HalResourceNotificationService, useValue: { handleRawError: () => false } },
        { provide: WorkPackageNotificationService, useValue: {} as any },
        { provide: WorkPackageCreateService, useValue: {} },
        { provide: StateService, useValue: {} },
        { provide: SchemaCacheService, useValue: {} },
      ],
    })
      .compileComponents()
      .then(() => {
        halResourceService = TestBed.inject(HalResourceService);
        injector = TestBed.inject(Injector);
        halResourceNotification = injector.get(HalResourceNotificationService);

        halResourceService.registerResource('WorkPackage', { cls: WorkPackageResource });
      });
  }));

  describe('when creating an empty work package', () => {
    beforeEach(createWorkPackage);

    it('should have an attachments property of type `AttachmentCollectionResource`', () => {
      expect(workPackage.attachments).toEqual(jasmine.any(AttachmentCollectionResource));
    });

    it('should return true for `isNewResource`', () => {
      expect(isNewResource(workPackage)).toBeTruthy();
    });
  });

  describe('when retrieving `canAddAttachment`', () => {
    beforeEach(createWorkPackage);

    it('should be true for new work packages', () => {
      expect(workPackage.canAddAttachments).toEqual(true);
    });

    it('when work package is not new', () => {
      workPackage.$source.id = 420;
      expect(workPackage.canAddAttachments).toEqual(false);
    });

    it('when the work work package has no `addAttachment` link and is not new', () => {
      workPackage.$source.id = 69;
      workPackage.$links.addAttachment = null as any;
      expect(workPackage.canAddAttachments).toEqual(false);
    });

    it('when the work work package has an `addAttachment` link', () => {
      workPackage.$links.addAttachment = <any> _.noop;
      expect(workPackage.canAddAttachments).toEqual(true);
    });
  });

  describe('when a work package is created with attachments and activities', () => {
    beforeEach(() => {
      source = {
        _links: {
          schema: { _type: 'Schema', href: 'schema' },
          attachments: { href: 'attachments' },
          activities: { href: 'activities' },
        },
        isNew: true,
      };
      createWorkPackage();
    });
  });

  describe('when using removeAttachment', () => {
    let file:any;
    let attachment:any;

    beforeEach(() => {
      file = {};
      attachment = {
        $isHal: true,
        delete: () => undefined,
      };

      createWorkPackage();
      workPackage.attachments.elements = [attachment];
    });

    describe('when the attachment is an attachment resource', () => {
      beforeEach(() => {
        attachment.delete = jasmine.createSpy('delete').and.returnValue(Promise.resolve());
        spyOn(workPackage, 'updateAttachments');
      });

      it('should call its delete method', (done) => {
        workPackage.removeAttachment(attachment).then(() => {
          expect(attachment.delete).toHaveBeenCalled();
          done();
        });
      });

      describe('when the deletion gets resolved', () => {
        it('should call updateAttachments()', (done) => {
          workPackage.removeAttachment(attachment).then(() => {
            expect(workPackage.updateAttachments).toHaveBeenCalled();
            done();
          });
        });
      });

      describe('when an error occurs', () => {
        let errorStub:jasmine.Spy;

        beforeEach(() => {
          attachment.delete = jasmine.createSpy('delete')
            .and.returnValue(Promise.reject({ foo: 'bar' }));

          errorStub = spyOn(halResourceNotification, 'handleRawError');
        });

        it('should call the handleRawError notification', (done) => {
          workPackage.removeAttachment(attachment).then(() => {
            expect(errorStub).toHaveBeenCalled();
            done();
          });
        });

        it('should not remove the attachment from the elements array', (done) => {
          workPackage.removeAttachment(attachment).then(() => {
            expect(workPackage.attachments.elements.length).toEqual(1);
            done();
          });
        });
      });
    });
  });
});
