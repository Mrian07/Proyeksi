

import { input } from 'reactivestates';
import { Injectable } from '@angular/core';
import { APIV3Service } from 'core-app/core/apiv3/api-v3.service';
import { take } from 'rxjs/operators';
import { CollectionResource } from 'core-app/features/hal/resources/collection-resource';
import { HelpTextResource } from 'core-app/features/hal/resources/help-text-resource';

@Injectable({ providedIn: 'root' })
export class AttributeHelpTextsService {
  private helpTexts = input<HelpTextResource[]>();

  constructor(private apiV3Service:APIV3Service) {
  }

  /**
   * Search for a given attribute help text
   *
   * @param attribute
   * @param scope
   */
  public require(attribute:string, scope:string):Promise<HelpTextResource|undefined> {
    this.load();

    return new Promise<HelpTextResource|undefined>((resolve, reject) => {
      this.helpTexts
        .valuesPromise()
        .then(() => resolve(this.find(attribute, scope)));
    });
  }

  /**
   * Search for a given attribute help text
   *
   */
  public requireById(id:string|number):Promise<HelpTextResource|undefined> {
    this.load();

    return this
      .helpTexts
      .values$()
      .pipe(
        take(1),
      )
      .toPromise()
      .then(() => {
        const value = this.helpTexts.getValueOr([]);
        return _.find(value, (element) => element.id?.toString() === id.toString());
      });
  }

  private load():void {
    this.helpTexts.putFromPromiseIfPristine(() => this.apiV3Service
      .help_texts
      .get()
      .toPromise()
      .then((resources:CollectionResource<HelpTextResource>) => resources.elements));
  }

  private find(attribute:string, scope:string):HelpTextResource|undefined {
    const value = this.helpTexts.getValueOr([]);
    return _.find(value, (element) => element.scope === scope && element.attribute === attribute);
  }
}
