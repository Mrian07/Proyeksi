

import { ChangeDetectionStrategy, Component, Input } from '@angular/core';
import { UserResource } from 'core-app/features/hal/resources/user-resource';
import { I18nService } from 'core-app/core/i18n/i18n.service';

@Component({
  selector: 'op-user-link',
  template: `
    <a *ngIf="href"
       [attr.href]="href"
       [attr.title]="label"
       [textContent]="name">
    </a>
    <ng-container *ngIf="!href">
      {{ name }}
    <ng-container>
  `,
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class UserLinkComponent {
  @Input() user:UserResource;

  constructor(readonly I18n:I18nService) {
  }

  public get href() {
    return this.user && this.user.showUserPath;
  }

  public get name() {
    return this.user && this.user.name;
  }

  public get label() {
    return this.I18n.t('js.label_author', { user: this.name });
  }
}
