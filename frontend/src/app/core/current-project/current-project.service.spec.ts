

/* jshint expr: true */

import { PathHelperService } from 'core-app/core/path-helper/path-helper.service';
import { CurrentProjectService } from './current-project.service';

describe('currentProject service', () => {
  let element:JQuery;
  let currentProject:CurrentProjectService;

  const apiV3Stub:any = {
    projects: {
      id: (id:string) => ({ toString: () => `/api/v3/projects/${id}` }),
    },
  };

  beforeEach(() => {
    currentProject = new CurrentProjectService(new PathHelperService(), apiV3Stub);
  });

  describe('with no meta present', () => {
    it('returns null values', () => {
      expect(currentProject.id).toBeNull();
      expect(currentProject.identifier).toBeNull();
      expect(currentProject.name).toBeNull();
      expect(currentProject.apiv3Path).toBeNull();
      expect(currentProject.inProjectContext).toBeFalsy();
    });
  });

  describe('with a meta value present', () => {
    beforeEach(() => {
      const html = `
          <meta name="current_project" data-project-name="Foo 1234" data-project-id="1" data-project-identifier="foobar"/>
        `;

      element = jQuery(html);
      jQuery(document.body).append(element);
      currentProject.detect();
    });

    afterEach((() => {
      element.remove();
    }));

    it('returns correct values', () => {
      expect(currentProject.inProjectContext).toBeTruthy();
      expect(currentProject.id).toEqual('1');
      expect(currentProject.name).toEqual('Foo 1234');
      expect(currentProject.identifier).toEqual('foobar');
      expect(currentProject.apiv3Path).toEqual('/api/v3/projects/1');
    });
  });
});
