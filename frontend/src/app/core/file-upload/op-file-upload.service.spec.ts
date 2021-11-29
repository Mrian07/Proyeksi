

import { OpenProjectDirectFileUploadService } from 'core-app/core/file-upload/op-direct-file-upload.service';
import { HttpClientTestingModule, HttpTestingController } from '@angular/common/http/testing';
import { getTestBed, TestBed } from '@angular/core/testing';
import { HalResourceService } from 'core-app/features/hal/services/hal-resource.service';
import { States } from 'core-app/core/states/states.service';
import { I18nService } from 'core-app/core/i18n/i18n.service';
import { OpenProjectFileUploadService, UploadFile, UploadResult } from './op-file-upload.service';

describe('opFileUpload service', () => {
  let injector:TestBed;
  let service:OpenProjectFileUploadService;
  let httpMock:HttpTestingController;

  beforeEach(() => {
    TestBed.configureTestingModule({
      imports: [HttpClientTestingModule],
      providers: [
        { provide: States, useValue: new States() },
        I18nService,
        OpenProjectFileUploadService,
        OpenProjectDirectFileUploadService,
        HalResourceService,
      ],
    });

    injector = getTestBed();
    service = injector.get(OpenProjectFileUploadService);
    httpMock = injector.get(HttpTestingController);
  });

  afterEach(() => {
    httpMock.verify();
  });

  describe('when uploading multiple files', () => {
    let result:UploadResult;
    const file:UploadFile = new File([JSON.stringify({
      name: 'name',
      description: 'description',
    })], 'name');

    beforeEach(() => {
      result = service.upload('/my/api/path', [file, file]);
      httpMock.match('/my/api/path').forEach((req) => {
        expect(req.request.method).toBe('POST');
        req.flush({});
      });
    });

    it('should call upload once for every file, that is no directory', () => {
      expect(result.uploads.length).toEqual(2);
    });

    it('should return a resolved promise that is the summary of the uploads', (done) => {
      result.finished.then(done);
    });
  });
});
