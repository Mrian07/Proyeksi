

import { TestBed, waitForAsync } from '@angular/core/testing';
import { BcfApiService } from 'core-app/features/bim/bcf/api/bcf-api.service';
import { BcfResourceCollectionPath, BcfResourcePath } from 'core-app/features/bim/bcf/api/bcf-path-resources';
import { BcfTopicPaths } from 'core-app/features/bim/bcf/api/topics/bcf-topic.paths';

describe('BcfApiService', () => {
  let service:BcfApiService;

  beforeEach(waitForAsync(() => {
    // noinspection JSIgnoredPromiseFromCall
    TestBed.configureTestingModule({
      providers: [
        BcfApiService,
      ],
    })
      .compileComponents()
      .then(() => {
        service = TestBed.inject(BcfApiService);
      });
  }));

  describe('building the path', () => {
    it('can build projects', () => {
      const subject = service.projects;
      expect(subject.toPath()).toEqual('/api/bcf/2.1/projects');
    });

    it('can build project', () => {
      const subject = service.projects.id('foo');
      expect(subject.toPath()).toEqual('/api/bcf/2.1/projects/foo');
    });

    it('can build topics', () => {
      const subject = service.projects.id('foo').topics;
      expect(subject.toPath()).toEqual('/api/bcf/2.1/projects/foo/topics');
    });

    it('can build topic', () => {
      const subject = service.projects.id('foo').topics.id('bar');
      expect(subject.toPath()).toEqual('/api/bcf/2.1/projects/foo/topics/bar');
    });

    it('can build viewpoints', () => {
      const subject = service.projects.id('foo').topics.id('bar').viewpoints;
      expect(subject.toPath()).toEqual('/api/bcf/2.1/projects/foo/topics/bar/viewpoints');
    });

    it('can build comments', () => {
      const subject = service.projects.id('foo').topics.id('bar').comments;
      expect(subject.toPath()).toEqual('/api/bcf/2.1/projects/foo/topics/bar/comments');
    });
  });

  describe('#parse', () => {
    it('can parse projects', () => {
      const href = '/api/bcf/2.1/projects';
      const subject:any = service.parse(href);
      expect(subject).toBeInstanceOf(BcfResourceCollectionPath);
      expect(subject.segment).toEqual('projects');
      expect(subject.toPath()).toEqual(href);
    });

    it('can parse single project', () => {
      const href = '/api/bcf/2.1/projects/foo';
      const subject:any = service.parse(href);
      expect(subject).toBeInstanceOf(BcfResourcePath);
      expect(subject.id).toEqual('foo');
      expect(subject.toPath()).toEqual(href);
    });

    it('can parse topics in projects', () => {
      const href = '/api/bcf/2.1/projects/foo/topics';
      const subject:any = service.parse(href);
      expect(subject).toBeInstanceOf(BcfResourceCollectionPath);
      expect(subject.segment).toEqual('topics');
      expect(subject.toPath()).toEqual(href);
    });

    it('can parse single topic in projects', () => {
      const href = '/api/bcf/2.1/projects/foo/topics/0efc0da-b4d5-4933-bcb6-e01513ee2bcc';
      const subject:any = service.parse(href);
      expect(subject).toBeInstanceOf(BcfTopicPaths);
      expect(subject.comments).toBeDefined();
      expect(subject.viewpoints).toBeDefined();
      expect(subject.id).toEqual('0efc0da-b4d5-4933-bcb6-e01513ee2bcc');
      expect(subject.toPath()).toEqual(href);
    });

    it('can parse viewpoints in topic', () => {
      const href = '/api/bcf/2.1/projects/foo/topics/0efc0da-b4d5-4933-bcb6-e01513ee2bcc/viewpoints';
      const subject:any = service.parse(href);
      expect(subject).toBeInstanceOf(BcfResourceCollectionPath);
      expect(subject.segment).toEqual('viewpoints');
      expect(subject.toPath()).toEqual(href);
    });

    it('can parse single viewpoint in topic', () => {
      const href = '/api/bcf/2.1/projects/demo-bcf-management-project/topics/00efc0da-b4d5-4933-bcb6-e01513ee2bcc/viewpoints/dfca6c25-832f-6a94-53ca-48d510b6bad9';
      const subject:any = service.parse(href);
      expect(subject).toBeInstanceOf(BcfResourcePath);
      expect(subject.id).toEqual('dfca6c25-832f-6a94-53ca-48d510b6bad9');
      expect(subject.toPath()).toEqual(href);
    });
  });
});
