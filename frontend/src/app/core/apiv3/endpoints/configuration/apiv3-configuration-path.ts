

import { APIv3GettableResource } from 'core-app/core/apiv3/paths/apiv3-resource';
import { ConfigurationResource } from 'core-app/features/hal/resources/configuration-resource';
import { Observable } from 'rxjs';
import { shareReplay } from 'rxjs/operators';
import { APIV3Service } from 'core-app/core/apiv3/api-v3.service';

export class Apiv3ConfigurationPath extends APIv3GettableResource<ConfigurationResource> {
  private $configuration:Observable<ConfigurationResource>;

  constructor(protected apiRoot:APIV3Service,
    readonly basePath:string) {
    super(apiRoot, basePath, 'configuration');
  }

  public get():Observable<ConfigurationResource> {
    if (this.$configuration) {
      return this.$configuration;
    }

    return this.$configuration = this.halResourceService
      .get<ConfigurationResource>(this.path)
      .pipe(
        shareReplay(),
      );
  }
}
