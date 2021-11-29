

import { Injectable } from '@angular/core';
import { HalResource } from 'core-app/features/hal/resources/hal-resource';

@Injectable({ providedIn: 'root' })
export class HalResourceSortingService {
  /**
   * List of sortable properties by HAL type
   */
  private config:{ [typeName:string]:string } = {
    user: 'name',
    project: 'name',
  };

  constructor() {
  }

  /**
   * Sort the given HalResource based on its type.
   * If the type is not given, guess from the first element.
   *
   * @param {T[]} elements A collection of HalResources of type T
   * @param {string} type The HAL type of the collection
   * @returns {T[]} The sorted collection of HalResources
   */
  public sort<T extends HalResource>(elements:T[], type?:string) {
    if (elements.length === 0) {
      return elements;
    }

    const halType = type || elements[0]._type;
    if (!halType) {
      return elements;
    }

    const property = this.sortingProperty(halType);
    if (property) {
      return _.sortBy<T>(elements, (v) => v[property].toLowerCase());
    }
    return elements;
  }

  /**
   * Transform the HAL type into the sorting property map.
   *
   *  - Removes the leading multi identifier [] (e.g., from []User)
   *  - Transforms to lowercase
   *
   * @param {string} type
   * @returns {string | undefined}
   */
  public sortingProperty(type:string):string | undefined {
    // Remove multi identifier and map to lowercase
    type = type
      .toLowerCase()
      .replace(/^\[\]/, '');

    return this.config[type];
  }

  public hasSortingProperty(type:string) {
    return this.sortingProperty(type) !== undefined;
  }
}
