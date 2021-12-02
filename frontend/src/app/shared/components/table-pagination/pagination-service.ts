

import { Injectable } from '@angular/core';
import { ConfigurationService } from 'core-app/core/config/configuration.service';

export const DEFAULT_PAGINATION_OPTIONS = {
  maxVisiblePageOptions: 6,
  optionsTruncationSize: 1,
};

export interface IPaginationOptions {
  perPage:number;
  perPageOptions:number[];
  maxVisiblePageOptions:number;
  optionsTruncationSize:number;
}

export interface PaginationObject {
  pageSize:number;
  offset:number;
}

@Injectable()
export class PaginationService {
  private paginationOptions:IPaginationOptions;

  constructor(private configuration:ConfigurationService) {
    this.loadPaginationOptions();
  }

  public getCachedPerPage(initialPageOptions:number[]):number {
    const value = this.localStoragePerPage;
    const initialLength = initialPageOptions?.length || 0;

    if (value !== null && value > 0 && (initialLength === 0 || initialPageOptions?.indexOf(value) !== -1)) {
      return value;
    }

    if (initialLength > 0) {
      return initialPageOptions[0];
    }

    return 20;
  }

  private get localStoragePerPage() {
    const value = window.ProyeksiApp.guardedLocalStorage('pagination.perPage') as string;

    if (value !== undefined) {
      return parseInt(value, 10);
    }
    return null;
  }

  public getPaginationOptions() {
    return this.paginationOptions;
  }

  public get isPerPageKnown() {
    return !!(this.localStoragePerPage || this.paginationOptions);
  }

  public getPerPage() {
    return this.localStoragePerPage || this.paginationOptions.perPage;
  }

  public getMaxVisiblePageOptions() {
    return _.get(this.paginationOptions, 'maxVisiblePageOptions', DEFAULT_PAGINATION_OPTIONS.maxVisiblePageOptions);
  }

  public getOptionsTruncationSize() {
    return _.get(this.paginationOptions, 'optionsTruncationSize', DEFAULT_PAGINATION_OPTIONS.optionsTruncationSize);
  }

  public setPerPage(perPage:number) {
    window.ProyeksiApp.guardedLocalStorage('pagination.perPage', perPage.toString());
    this.paginationOptions.perPage = perPage;
  }

  public getPerPageOptions() {
    return this.paginationOptions.perPageOptions;
  }

  public setPerPageOptions(perPageOptions:number[]) {
    this.paginationOptions.perPageOptions = perPageOptions;
  }

  public loadPaginationOptions() {
    return this.configuration.initialized.then(() => {
      this.paginationOptions = {
        perPage: this.getCachedPerPage(this.configuration.perPageOptions),
        perPageOptions: this.configuration.perPageOptions,
        maxVisiblePageOptions: DEFAULT_PAGINATION_OPTIONS.maxVisiblePageOptions,
        optionsTruncationSize: DEFAULT_PAGINATION_OPTIONS.optionsTruncationSize,
      };

      return this.paginationOptions;
    });
  }
}
