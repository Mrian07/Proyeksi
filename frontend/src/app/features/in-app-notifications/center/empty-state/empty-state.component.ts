

import {
  ChangeDetectionStrategy,
  Component,
} from '@angular/core';
import { I18nService } from 'core-app/core/i18n/i18n.service';
import { imagePath } from 'core-app/shared/helpers/images/path-helper';
import { IanCenterService } from '../state/ian-center.service';
import {
  debounceTime,
  distinctUntilChanged,
} from 'rxjs/operators';
import { IanBellService } from 'core-app/features/in-app-notifications/bell/state/ian-bell.service';
import { combineLatest } from 'rxjs';

@Component({
  templateUrl: './empty-state.component.html',
  changeDetection: ChangeDetectionStrategy.OnPush,
  styleUrls: ['./empty-state.component.sass'],
  selector: 'op-empty-state',
})
export class EmptyStateComponent {
  image = {
    no_notification: imagePath('notification-center/empty-state-no-notification.svg'),
    no_selection: imagePath('notification-center/empty-state-no-selection.svg'),
    loading: imagePath('notification-center/notification_loading.gif'),
  };

  text = {
    no_notification: this.I18n.t('js.notifications.center.empty_state.no_notification'),
    no_notification_with_current_filter: this.I18n.t('js.notifications.center.empty_state.no_notification_with_current_filter'),
    no_selection: this.I18n.t('js.notifications.center.empty_state.no_selection'),
  };

  private hasNotifications$ = this.storeService.query.hasNotifications$;

  private totalCount$ = this.bellService.unread$;

  dataChanged$ = combineLatest([
    this.hasNotifications$,
    this.totalCount$,
  ])
    .pipe(
      distinctUntilChanged(),
      debounceTime(350),
    );

  constructor(
    readonly I18n:I18nService,
    readonly storeService:IanCenterService,
    readonly bellService:IanBellService,
  ) {
  }

  noNotificationText(hasNotifications:boolean, totalNotifications:number):string {
    return (!hasNotifications && totalNotifications > 0) ? this.text.no_notification_with_current_filter : this.text.no_notification;
  }
}
