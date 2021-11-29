

import { Injectable } from '@angular/core';
import { forkJoin, of } from 'rxjs';
import {
  distinctUntilChanged, map, mergeMap, take,
} from 'rxjs/operators';
import { APIV3Service } from 'core-app/core/apiv3/api-v3.service';
import { CapabilityResource } from 'core-app/features/hal/resources/capability-resource';
import { CollectionResource } from 'core-app/features/hal/resources/collection-resource';
import { FilterOperator } from 'core-app/shared/helpers/api-v3/api-v3-filter-builder';
import { CurrentUser, CurrentUserStore } from './current-user.store';
import { CurrentUserQuery } from './current-user.query';

@Injectable({ providedIn: 'root' })
export class CurrentUserService {
  private PAGE_FETCH_SIZE = 1000;

  constructor(
    private apiV3Service:APIV3Service,
    private currentUserStore:CurrentUserStore,
    private currentUserQuery:CurrentUserQuery,
  ) {
    this.setupLegacyDataListeners();
  }

  public capabilities$ = this.currentUserQuery.capabilities$;

  public isLoggedIn$ = this.currentUserQuery.isLoggedIn$;

  public user$ = this.currentUserQuery.user$;

  /**
   * Set the current user object
   *
   * This refetches the global and current project capabilities
   */
  public setUser(user:CurrentUser) {
    this.currentUserStore.update((state) => ({
      ...state,
      ...user,
    }));

    this.fetchCapabilities([]);
  }

  /**
   * Fetch all capabilities for certain contexts
   */
  public fetchCapabilities(contexts:string[] = []) {
    this.user$.pipe(take(1)).subscribe((user) => {
      if (!user.id) {
        this.currentUserStore.update((state) => ({
          ...state,
          capabilities: [],
        }));

        return;
      }

      const filters:[string, FilterOperator, string[]][] = [['principal', '=', [user.id]]];
      if (contexts.length) {
        filters.push(['context', '=', contexts.map((context) => (context === 'global' ? 'g' : `p${context}`))]);
      }

      this.apiV3Service.capabilities.list({
        pageSize: this.PAGE_FETCH_SIZE,
        filters,
      })
        .pipe(
          mergeMap((data:CollectionResource<CapabilityResource>) => {
          // The data we've loaded might not contain all capabilities. Some responses might have thousands of
          // capabilites, and our page size is restricted. If this is the case, we branch out and sent out parallel
          // requests for each of the other pages.
            if (data.total > this.PAGE_FETCH_SIZE) {
              const remaining = data.total - this.PAGE_FETCH_SIZE;
              const pagesRemaining = Math.ceil(remaining / this.PAGE_FETCH_SIZE);
              const calls = (new Array(pagesRemaining))
                .fill(null)
                .map((_, i) => this.apiV3Service.capabilities.list({
                  pageSize: this.PAGE_FETCH_SIZE,
                  offset: i + 2, // Page offsets are 1-indexed, and we already fetched the first page
                  filters,
                }));

              // Branch out and fetch all remaining pages in parallel.
              // Afterwards, merge the resulting list
              return forkJoin(...calls).pipe(
                map(
                  (results:CollectionResource<CapabilityResource>[]) => results.reduce(
                    (acc, next) => acc.concat(next.elements),
                    data.elements,
                  ),
                ),
              );
            }

            // The current page is the only page, return the results.
            return of(data.elements);
          }),
          // Elements may incorrectly be undefined here due to the way the representer works
          map((elements) => elements || []),
        )
        .subscribe((capabilities) => {
          this.currentUserStore.update((state) => ({
            ...state,
            capabilities: [
              ...capabilities,
              ...(state.capabilities || []).filter((cap) => !!capabilities.find((newCap) => newCap.id === cap.id)),
            ],
          }));
        });
    });

    return this.currentUserQuery.capabilities$;
  }

  /**
   * Returns the users' capabilities filtered by context
   */
  public capabilitiesForContext$(contextId:string) {
    return this.capabilities$.pipe(
      map((capabilities) => capabilities.filter((cap) => cap.context.href.endsWith(`/${contextId}`))),
      distinctUntilChanged(),
    );
  }

  /**
   * Returns an Observable<boolean> indicating whether the user has the required capabilities in the provided context.
   */
  public hasCapabilities$(action:string|string[], contextId = 'global') {
    const actions = _.castArray(action);
    return this.capabilitiesForContext$(contextId).pipe(
      map((capabilities) => actions.reduce(
        (acc, contextAction) => acc && !!capabilities.find((cap) => cap.action.href.endsWith(`/api/v3/actions/${contextAction}`)),
        capabilities.length > 0,
      )),
      distinctUntilChanged(),
    );
  }

  /**
   * Returns an Observable<boolean> indicating whether the user has any of the required capabilities in the provided context.
   */
  public hasAnyCapabilityOf$(actions:string|string[], contextId = 'global') {
    const actionsToFilter = _.castArray(actions);
    return this.capabilitiesForContext$(contextId).pipe(
      map((capabilities) => capabilities.reduce(
        (acc, cap) => acc || !!actionsToFilter.find((action) => cap.action.href.endsWith(`/api/v3/actions/${action}`)),
        false,
      )),
      distinctUntilChanged(),
    );
  }

  // Everything below this is deprecated legacy interfacing and should not be used

  private setupLegacyDataListeners() {
    this.currentUserQuery.user$.subscribe((user) => (this._user = user));
    this.currentUserQuery.isLoggedIn$.subscribe((isLoggedIn) => (this._isLoggedIn = isLoggedIn));
  }

  private _isLoggedIn = false;

  /** @deprecated Use the store mechanism `currentUserQuery.isLoggedIn$` */
  public get isLoggedIn() {
    return this._isLoggedIn;
  }

  private _user:CurrentUser = {
    id: null,
    name: null,
    mail: null,
  };

  /** @deprecated Use the store mechanism `currentUserQuery.user$` */
  public get userId() {
    return this._user.id || '';
  }

  /** @deprecated Use the store mechanism `currentUserQuery.user$` */
  public get name() {
    return this._user.name || '';
  }

  /** @deprecated Use the store mechanism `currentUserQuery.user$` */
  public get mail() {
    return this._user.mail || '';
  }

  /** @deprecated Use the store mechanism `currentUserQuery.user$` */
  public get href() {
    return `/api/v3/users/${this.userId}`;
  }

  /** @deprecated Use `I18nService.locale` instead */
  public get language() {
    return I18n.locale || 'en';
  }
}
