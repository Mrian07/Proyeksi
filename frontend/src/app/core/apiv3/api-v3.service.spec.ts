

import { TestBed, waitForAsync } from '@angular/core/testing';
import { APIV3Service } from 'core-app/core/apiv3/api-v3.service';
import { PathHelperService } from 'core-app/core/path-helper/path-helper.service';
import { States } from 'core-app/core/states/states.service';

describe('APIv3Service', () => {
  let service:APIV3Service;

  beforeEach(waitForAsync(() => {
    // noinspection JSIgnoredPromiseFromCall
    TestBed.configureTestingModule({
      providers: [
        States,
        PathHelperService,
        APIV3Service,
      ],
    })
      .compileComponents()
      .then(() => {
        service = TestBed.inject(APIV3Service);
      });
  }));

  function encodeParams(object:any) {
    return new URLSearchParams(object).toString();
  }

  describe('apiV3', () => {
    const projectIdentifier = 'majora';

    it("should provide the project's path", () => {
      expect(service.projects.id(projectIdentifier).path).toEqual('/api/v3/projects/majora');
    });

    it('should provide a path to work package query on subject or ID ', () => {
      let params = {
        filters: '[{"typeahead":{"operator":"**","values":["bogus"]}}]',
        sortBy: '[["updatedAt","desc"]]',
        offset: '1',
        pageSize: '10',
      };

      expect(
        service.work_packages.filterByTypeaheadOrId('bogus').path,
      ).toEqual(`/api/v3/work_packages?${encodeParams(params)}`);

      params = {
        filters: '[{"id":{"operator":"=","values":["1234"]}}]',
        sortBy: '[["updatedAt","desc"]]',
        offset: '1',
        pageSize: '10',
      };
      expect(
        service.work_packages.filterByTypeaheadOrId('1234', true).path,
      ).toEqual(`/api/v3/work_packages?${encodeParams(params)}`);
    });
  });
});
