

import { Injectable, OnDestroy } from '@angular/core';
import { I18nService } from 'core-app/core/i18n/i18n.service';
import { Observable } from 'rxjs';
import { StateService, TransitionService } from '@uirouter/core';
import { input } from 'reactivestates';
import { takeUntil } from 'rxjs/operators';

export const bimListViewIdentifier = 'list';
export const bimTableViewIdentifier = 'table';
export const bimSplitViewCardsIdentifier = 'splitCards';
export const bimSplitViewListIdentifier = 'splitList';
export const bimViewerViewIdentifier = 'viewer';

export type BimViewState = 'list'|'viewer'|'splitList'|'splitCards'|'table';

@Injectable()
export class BimViewService implements OnDestroy {
  private _state = input<BimViewState>();

  public text:any = {
    list: this.I18n.t('js.views.card'),
    viewer: this.I18n.t('js.ifc_models.views.viewer'),
    splitList: this.I18n.t('js.ifc_models.views.split'),
    splitCards: this.I18n.t('js.ifc_models.views.split_cards'),
    table: this.I18n.t('js.views.list'),
  };

  public icon:any = {
    list: 'icon-view-card',
    viewer: 'icon-view-model',
    splitList: 'icon-view-split-viewer-table',
    splitCards: 'icon-view-split2',
    table: 'icon-view-list',
  };

  private transitionFn:Function;

  constructor(readonly I18n:I18nService,
    readonly transitions:TransitionService,
    readonly state:StateService) {
    this.detectView();

    this.transitionFn = this.transitions.onSuccess({}, (transition) => {
      this.detectView();
    });
  }

  get view$():Observable<BimViewState> {
    return this._state.values$();
  }

  public observeUntil(unsubscribe:Observable<any>) {
    return this.view$.pipe(takeUntil(unsubscribe));
  }

  get current():BimViewState {
    return this._state.getValueOr(bimSplitViewCardsIdentifier);
  }

  public currentViewerState():BimViewState {
    if (this.state.includes('bim.partitioned.list')) {
      return this.state.params?.cards
        ? bimListViewIdentifier
        : bimTableViewIdentifier;
    } if (this.state.includes('bim.**.model')) {
      return bimViewerViewIdentifier;
    } if (this.state.includes('bim.partitioned.show')) {
      return this.state.params?.cards || this.state.params?.cards == null
        ? bimListViewIdentifier
        : bimTableViewIdentifier;
    }
    return this.state.params?.cards || this.state.params?.cards == null
      ? bimSplitViewCardsIdentifier
      : bimSplitViewListIdentifier;
  }

  private detectView() {
    this._state.putValue(this.currentViewerState());
  }

  ngOnDestroy() {
    this.transitionFn();
  }
}
