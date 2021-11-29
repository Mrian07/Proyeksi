

import { WorkPackageViewFocusService } from 'core-app/features/work-packages/routing/wp-view-base/view-services/wp-view-focus.service';
import { StateService, TransitionService } from '@uirouter/core';
import {
  ChangeDetectionStrategy, ChangeDetectorRef, Component, OnDestroy,
} from '@angular/core';
import { AbstractWorkPackageButtonComponent } from 'core-app/features/work-packages/components/wp-buttons/wp-buttons.module';
import { I18nService } from 'core-app/core/i18n/i18n.service';
import { States } from 'core-app/core/states/states.service';
import { KeepTabService } from '../../wp-single-view-tabs/keep-tab/keep-tab.service';

@Component({
  templateUrl: '../wp-button.template.html',
  changeDetection: ChangeDetectionStrategy.OnPush,
  selector: 'wp-details-view-button',
})
export class WorkPackageDetailsViewButtonComponent extends AbstractWorkPackageButtonComponent implements OnDestroy {
  public projectIdentifier:string;

  public accessKey = 8;

  public activeState = 'work-packages.partitioned.list.details';

  public listState = 'work-packages.partitioned.list';

  public buttonId = 'work-packages-details-view-button';

  public buttonClass = 'toolbar-icon';

  public iconClass = 'icon-info2';

  public activateLabel:string;

  public deactivateLabel:string;

  private transitionListener:Function;

  constructor(
    readonly $state:StateService,
    readonly I18n:I18nService,
    readonly transitions:TransitionService,
    readonly cdRef:ChangeDetectorRef,
    public states:States,
    public wpTableFocus:WorkPackageViewFocusService,
    public keepTab:KeepTabService,
  ) {
    super(I18n);

    this.activateLabel = I18n.t('js.button_open_details');
    this.deactivateLabel = I18n.t('js.button_close_details');

    this.transitionListener = this.transitions.onSuccess({}, () => {
      this.isActive = this.$state.includes(this.activeState);
      this.cdRef.detectChanges();
    });
  }

  public ngOnDestroy() {
    super.ngOnDestroy();
    this.transitionListener();
  }

  public get label():string {
    if (this.isActive) {
      return this.deactivateLabel;
    }
    return this.activateLabel;
  }

  public isToggle():boolean {
    return true;
  }

  public performAction(event:Event) {
    if (this.isActive) {
      this.$state.go(this.listState);
    } else {
      this.openDetailsView();
    }
  }

  public openListView():void {
  }

  public openDetailsView():void {
    const params = {
      workPackageId: this.wpTableFocus.focusedWorkPackage,
    };

    this.keepTab.goCurrentDetailsState(params);
  }
}
