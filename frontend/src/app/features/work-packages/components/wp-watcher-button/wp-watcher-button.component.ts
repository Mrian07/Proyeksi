

import { WorkPackageResource } from 'core-app/features/hal/resources/work-package-resource';
import {
  ChangeDetectionStrategy, ChangeDetectorRef, Component, Input, OnInit,
} from '@angular/core';
import { I18nService } from 'core-app/core/i18n/i18n.service';
import { WorkPackageWatchersService } from 'core-app/features/work-packages/components/wp-single-view-tabs/watchers-tab/wp-watchers.service';
import { UntilDestroyedMixin } from 'core-app/shared/helpers/angular/until-destroyed.mixin';
import { APIV3Service } from 'core-app/core/apiv3/api-v3.service';

@Component({
  selector: 'wp-watcher-button',
  templateUrl: './wp-watcher-button.html',
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class WorkPackageWatcherButtonComponent extends UntilDestroyedMixin implements OnInit {
  @Input('workPackage') public workPackage:WorkPackageResource;

  @Input('showText') public showText = false;

  @Input('disabled') public disabled = false;

  public buttonText:string;

  public buttonTitle:string;

  public buttonClass:string;

  public buttonId:string;

  public watchIconClass:string;

  constructor(readonly I18n:I18nService,
    readonly wpWatchersService:WorkPackageWatchersService,
    readonly apiV3Service:APIV3Service,
    readonly cdRef:ChangeDetectorRef) {
    super();
  }

  ngOnInit() {
    this
      .apiV3Service
      .work_packages
      .id(this.workPackage)
      .requireAndStream()
      .pipe(
        this.untilDestroyed(),
      )
      .subscribe((wp:WorkPackageResource) => {
        this.workPackage = wp;
        this.setWatchStatus();
        this.cdRef.detectChanges();
      });
  }

  public get isWatched() {
    return this.workPackage.hasOwnProperty('unwatch');
  }

  public get displayWatchButton() {
    return this.isWatched || this.workPackage.hasOwnProperty('watch');
  }

  public toggleWatch() {
    const toggleLink = this.nextStateLink();

    toggleLink(toggleLink.$link.payload).then(() => {
      this.wpWatchersService.clear(this.workPackage.id);
      this
        .apiV3Service
        .work_packages
        .id(this.workPackage)
        .refresh();
    });
  }

  public nextStateLink() {
    const linkName = this.isWatched ? 'unwatch' : 'watch';
    return this.workPackage[linkName];
  }

  private setWatchStatus() {
    if (this.isWatched) {
      this.buttonTitle = this.I18n.t('js.label_unwatch_work_package');
      this.buttonText = this.I18n.t('js.label_unwatch');
      this.buttonClass = '-active';
      this.buttonId = 'unwatch-button';
      this.watchIconClass = 'icon-watched';
    } else {
      this.buttonTitle = this.I18n.t('js.label_watch_work_package');
      this.buttonText = this.I18n.t('js.label_watch');
      this.buttonClass = '';
      this.buttonId = 'watch-button';
      this.watchIconClass = 'icon-unwatched';
    }
  }
}