

import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { tap } from 'rxjs/operators';

export const indicatorLocationSelector = '.loading-indicator--location';
export const indicatorBackgroundSelector = '.loading-indicator--background';

export function withLoadingIndicator<T>(indicator:LoadingIndicator, delayStopTime?:number):(source:Observable<T>) => Observable<T> {
  return (source$:Observable<T>) => {
    indicator.start();

    return source$.pipe(
      tap(
        () => indicator.delayedStop(delayStopTime),
        () => indicator.stop(),
        () => indicator.stop(),
      ),
    );
  };
}

export function withDelayedLoadingIndicator<T>(indicator:() => LoadingIndicator):(source:Observable<T>) => Observable<T> {
  return (source$:Observable<T>) => {
    setTimeout(() => indicator().start());

    return source$.pipe(
      tap(
        () => undefined,
        () => indicator().stop(),
        () => indicator().stop(),
      ),
    );
  };
}

export class LoadingIndicator {
  private indicatorTemplate =
  `<div class="loading-indicator--background">
      <div class="loading-indicator">
        <div class="block-1"></div>
        <div class="block-2"></div>
        <div class="block-3"></div>
        <div class="block-4"></div>
        <div class="block-5"></div>
      </div>
    </div>
   `;

  constructor(public indicator:JQuery) {
  }

  public set promise(promise:Promise<unknown>) {
    this.start();

    // Keep bound method around
    const stopper = () => this.delayedStop();

    promise
      .then(stopper)
      .catch(stopper);
  }

  public start() {
    // If we're currently having an active indicator, remove that one
    this.stop();
    this.indicator.prepend(this.indicatorTemplate);
  }

  public delayedStop(time = 25) {
    setTimeout(() => this.stop(), time);
  }

  public stop() {
    this.indicator.find('.loading-indicator--background').remove();
  }
}

@Injectable({ providedIn: 'root' })
export class LoadingIndicatorService {
  // Provide shortcut to the primarily used indicators
  public get table() {
    return this.indicator('table');
  }

  public get wpDetails() {
    return this.indicator('wpDetails');
  }

  public get modal() {
    return this.indicator('modal');
  }

  // Returns a getter function to an indicator
  // in case the indicator is shown conditionally
  public getter(name:string):() => LoadingIndicator {
    return this.indicator.bind(this, name);
  }

  // Return an indicator by name or element
  public indicator(indicator:string|JQuery):LoadingIndicator {
    if (typeof indicator === 'string') {
      indicator = this.getIndicatorAt(indicator);
    }

    return new LoadingIndicator(indicator);
  }

  private getIndicatorAt(name:string):JQuery {
    return jQuery(indicatorLocationSelector).filter(`[data-indicator-name="${name}"]`);
  }
}
