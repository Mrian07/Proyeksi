

import { GitActionsService } from './git-actions.service';
import { WorkPackageResource } from "core-app/features/hal/resources/work-package-resource";
import { TestBed, waitForAsync } from '@angular/core/testing';
import { PathHelperService } from "core-app/core/path-helper/path-helper.service";

describe('GitActionsService', function() {
  let service:GitActionsService;

  const createWorkPackage = (overrides = {}) => {
    const defaults = {
      id: '42',
      subject: 'Find the question',
      description: {
        raw: 'I recently found the answer is 42. We need to compute the correct question.'
      },
      type: { name: 'User Story' },
      pathHelper: new PathHelperService()
    };
    const workPackage = { ...defaults, ...overrides };
    return(workPackage as WorkPackageResource);
  };

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      providers: [
        GitActionsService
      ]
    }).compileComponents()
      .then(() => {
        service = TestBed.inject(GitActionsService);
      });
  }));

  beforeEach(() => {
    service = new GitActionsService();
  });


  it('it produces a branch name, commit message, and a git command', () => {
    const wp = createWorkPackage();
    expect(service.branchName(wp)).toEqual('user-story/42-find-the-question');
    expect(service.commitMessage(wp)).toEqual(`[#42] Find the question

http://localhost:9876/work_packages/42
`);
    expect(service.gitCommand(wp)).toEqual(`git checkout -b 'user-story/42-find-the-question' && git commit --allow-empty -m '[#42] Find the question

http://localhost:9876/work_packages/42
'`);
  });

  it('shell-escapes output for the git-command', () => {
    const wp = createWorkPackage({ subject: "' && rm -rf / #" });
    expect(service.gitCommand(wp)).toEqual(`git checkout -b 'user-story/42-and-and-rm-rf' && git commit --allow-empty -m '[#42] \\' && rm -rf / #

http://localhost:9876/work_packages/42
'`);
  });
});