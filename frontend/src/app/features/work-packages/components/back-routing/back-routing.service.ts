

import { Injectable, Injector } from '@angular/core';
import { StateService, Transition } from '@uirouter/core';
import { KeepTabService } from 'core-app/features/work-packages/components/wp-single-view-tabs/keep-tab/keep-tab.service';
import { InjectField } from 'core-app/shared/helpers/angular/inject-field.decorator';

export interface BackRouteOptions {
  name:string;
  params:{};
  parent:string;
  baseRoute:string;
}

@Injectable({ providedIn: 'root' })
export class BackRoutingService {
  @InjectField() private $state:StateService;

  @InjectField() private keepTab:KeepTabService;

  private _backRoute:BackRouteOptions;

  constructor(readonly injector:Injector) {
  }

  private goToOtherState(route:string, params:Record<string, unknown>):Promise<unknown> {
    return this.$state.go(route, params);
  }

  private goBackToDetailsState(preferListOverSplit:boolean, baseRoute:string):void {
    if (preferListOverSplit) {
      this.goToOtherState(baseRoute, this.backRoute.params);
    } else {
      const state = `${baseRoute}.details.tabs`;
      const params = { ...this.backRoute.params, tabIdentifier: this.keepTab.currentDetailsTab };
      this.goToOtherState(state, params);
    }
  }

  private goBackNotToDetailsState():void {
    if (this.backRoute.parent) {
      this.goToOtherState(this.backRoute.name, this.backRoute.params).then(() => {
        this.$state.reload();
      });
    } else {
      this.goToOtherState(this.backRoute.name, this.backRoute.params);
    }
  }

  private goBackToPreviousState(preferListOverSplit:boolean, baseRoute:string):void {
    if (this.keepTab.isDetailsState(this.backRoute.parent)) {
      this.goBackToDetailsState(preferListOverSplit, baseRoute);
    } else {
      this.goBackNotToDetailsState();
    }
  }

  public goBack(preferListOverSplit = false) {
    // Default: back to list
    // When coming from a deep link or a create form
    const baseRoute = this.backRoute?.baseRoute || this.$state.current.data.baseRoute || 'work-packages.partitioned.list';
    // if we are in the first state
    if (!this.backRoute && baseRoute.includes('show')) {
      this.$state.reload();
    } else if (!this.backRoute || this.backRoute.name.includes('new')) {
      this.$state.go(baseRoute, this.$state.params);
    } else {
      this.goBackToPreviousState(preferListOverSplit, baseRoute);
    }
  }

  public goToBaseState() {
    const baseRoute = this.$state.current.data.baseRoute || 'work-packages.partitioned.list';
    this.$state.go(baseRoute, this.$state.params);
  }

  public sync(transition:Transition) {
    const fromState = transition.from();
    const toState = transition.to();

    // Set backRoute to know where we came from
    if (fromState.name
      && fromState.data
      && toState.data
      && fromState.data.parent !== toState.data.parent) {
      const paramsFromCopy = { ...transition.params('from') };
      this.backRoute = {
        name: fromState.name,
        params: paramsFromCopy,
        parent: fromState.data.parent,
        baseRoute: fromState.data.baseRoute,
      };
    }
  }

  public set backRoute(route:BackRouteOptions) {
    this._backRoute = route;
  }

  public get backRoute():BackRouteOptions {
    return this._backRoute;
  }
}
