

/* jshint expr: true */

import { CurrentProjectService } from 'core-app/core/current-project/current-project.service';
import { GlobalSearchService } from 'core-app/core/global_search/services/global-search.service';
import { I18nService } from 'core-app/core/i18n/i18n.service';
import { TestBed, waitForAsync } from '@angular/core/testing';
import { PathHelperService } from 'core-app/core/path-helper/path-helper.service';
import { States } from 'core-app/core/states/states.service';
import { APIV3Service } from 'core-app/core/apiv3/api-v3.service';

describe('Global search service', () => {
  let service:GlobalSearchService;
  let CurrentProject:CurrentProjectService;
  let CurrentProjectSpy;

  beforeEach(waitForAsync(() => {
    // noinspection JSIgnoredPromiseFromCall
    TestBed.configureTestingModule({
      providers: [
        I18nService,
        PathHelperService,
        States,
        APIV3Service,
        CurrentProjectService,
        GlobalSearchService,
      ],
    })
      .compileComponents()
      .then(() => {
        CurrentProject = TestBed.inject(CurrentProjectService);
        service = TestBed.inject(GlobalSearchService);
      });
  }));

  describe('outside a project', () => {
    beforeEach(() => {
      CurrentProjectSpy = spyOnProperty(CurrentProject, 'path', 'get').and.returnValue(null);
    });

    it('searchPath returns a correct path', () => {
      service.searchTerm = 'hello';
      expect(service.searchPath()).toEqual('/search?q=hello&work_packages=1');
    });

    it('searchPath encodes the search term', () => {
      service.searchTerm = '<%';
      expect(service.searchPath()).toEqual('/search?q=%3C%25&work_packages=1');
    });

    it('searchPath entails the current tab', () => {
      service.currentTab = 'wiki_pages';
      expect(service.searchPath()).toEqual('/search?q=&wiki_pages=1');
    });

    it('when currentTab is "all" searchPath does not add it as a params key', () => {
      service.currentTab = 'all';
      expect(service.searchPath()).toEqual('/search?q=');
    });
  });

  describe('within a project', () => {
    beforeEach(() => {
      CurrentProjectSpy = spyOnProperty(CurrentProject, 'path', 'get')
        .and
        .returnValue('/projects/myproject');
    });

    it('returns correct path containing the project', () => {
      expect(service.searchPath()).toEqual('/projects/myproject/search?q=&work_packages=1');
    });

    it('returns correct path containing the project scope', () => {
      service.projectScope = 'current_project';
      expect(service.searchPath()).toEqual('/projects/myproject/search?q=&work_packages=1&scope=current_project');
    });
  });
});
