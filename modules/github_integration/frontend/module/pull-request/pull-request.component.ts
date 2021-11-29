

import { Component, Input } from '@angular/core';
import { GithubCheckRunResource } from 'core-app/features/plugins/linked/openproject-github_integration/hal/resources/github-check-run-resource';
import { IGithubPullRequestResource } from "core-app/features/plugins/linked/openproject-github_integration/typings";
import { PathHelperService } from "core-app/core/path-helper/path-helper.service";
import { I18nService } from "core-app/core/i18n/i18n.service";

@Component({
  selector: 'github-pull-request',
  templateUrl: './pull-request.component.html',
  styleUrls: [
    './pull-request.component.sass',
    './pr-check.component.sass',
  ],
  host: { class: 'op-pull-request' }
})

export class PullRequestComponent {
  @Input() public pullRequest:IGithubPullRequestResource;

  public text = {
    label_created_by: this.I18n.t('js.label_created_by'),
    label_last_updated_on: this.I18n.t('js.label_last_updated_on'),
    label_details: this.I18n.t('js.label_details'),
    label_actions: this.I18n.t('js.github_integration.github_actions'),
  };

  constructor(readonly PathHelper:PathHelperService,
              readonly I18n:I18nService) {
  }

  get state() {
    if (this.pullRequest.state === 'open') {
      return (this.pullRequest.draft ? 'draft' : 'open');
    } else {
      return(this.pullRequest.merged ? 'merged' : 'closed');
    }
  }

  public checkRunStateText(checkRun:GithubCheckRunResource) {
    /* Github apps can *optionally* add an output object (and a title) which is the most relevant information to display.
       If that is not present, we can display the conclusion (which is present only on finished runs).
       If that is not present, we can always fall back to the status. */
    return(checkRun.outputTitle || checkRun.conclusion || checkRun.status);
  }

  public checkRunState(checkRun:GithubCheckRunResource) {
    return(checkRun.conclusion || checkRun.status);
  }

  public checkRunStateIcon(checkRun:GithubCheckRunResource) {
    switch (this.checkRunState(checkRun)) {
      case 'success': {
        return 'checkmark'
      }
      case 'queued': {
        return 'getting-started'
      }
      case 'in_progress': {
        return 'loading1'
      }
      case 'failure': {
        return 'cancel'
      }
      case 'timed_out': {
        return 'reminder'
      }
      case 'action_required': {
        return 'warning'
      }
      case 'stale': {
        return 'not-supported'
      }
      case 'skipped': {
        return 'redo'
      }
      case 'neutral': {
        return 'minus1'
      }
      case 'cancelled': {
        return 'minus1'
      }
      default: {
        return 'not-supported'
      }
    }
  }
}
