

import {
  Component, ElementRef, Input, OnInit,
} from '@angular/core';
import { I18nService } from 'core-app/core/i18n/i18n.service';
import { PathHelperService } from 'core-app/core/path-helper/path-helper.service';
import { APIV3Service } from 'core-app/core/apiv3/api-v3.service';

import { TimezoneService } from 'core-app/core/datetime/timezone.service';
import { AvatarSize, PrincipalRendererService } from './principal-renderer.service';
import { PrincipalLike } from './principal-types';
import { PrincipalHelper } from './principal-helper';
import PrincipalPluralType = PrincipalHelper.PrincipalPluralType;

export const principalSelector = 'op-principal';

@Component({
  template: '',
  selector: principalSelector,
})
export class OpPrincipalComponent implements OnInit {
  /** If coming from angular, pass a principal resource if available */
  @Input() principal:PrincipalLike;

  @Input('hide-avatar') hideAvatar = false;

  @Input('hide-name') hideName = false;

  @Input() link = true;

  @Input() size:AvatarSize = 'default';

  public constructor(readonly elementRef:ElementRef,
    readonly PathHelper:PathHelperService,
    readonly principalRenderer:PrincipalRendererService,
    readonly I18n:I18nService,
    readonly apiV3Service:APIV3Service,
    readonly timezoneService:TimezoneService) {

  }

  ngOnInit() {
    const element = this.elementRef.nativeElement;

    if (!this.principal) {
      this.principal = this.principalFromDataset(element);
      this.hideAvatar = element.dataset.hideAvatar === 'true';
      this.hideName = element.dataset.hideName === 'true';
      this.link = element.dataset.link === 'true';
      this.size = element.dataset.size ?? 'default';
    }

    this.principalRenderer.render(
      element,
      this.principal,
      {
        hide: this.hideName,
        link: this.link,
      },
      {
        hide: this.hideAvatar,
        size: this.size,
      },
    );
  }

  private principalFromDataset(element:HTMLElement) {
    const id = element.dataset.principalId!;
    const name = element.dataset.principalName!;
    const type = element.dataset.principalType;
    const plural = `${type}s` as PrincipalPluralType;
    const href = this.apiV3Service[plural].id(id).toString();

    return {
      id,
      name,
      href,
    };
  }
}
