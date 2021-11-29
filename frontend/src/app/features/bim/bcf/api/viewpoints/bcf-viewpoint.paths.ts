

import { HTTPClientHeaders, HTTPClientParamMap } from 'core-app/features/hal/http/http.interfaces';
import { BcfResourcePath } from 'core-app/features/bim/bcf/api/bcf-path-resources';
import { BcfApiRequestService } from 'core-app/features/bim/bcf/api/bcf-api-request.service';
import { BcfViewpointSelectionPath } from 'core-app/features/bim/bcf/api/viewpoints/bcf-viewpoint-selection.paths';
import { Observable } from 'rxjs';
import { BcfViewpointVisibilityPaths } from 'core-app/features/bim/bcf/api/viewpoints/bcf-viewpoint-visibility.paths';
import { BcfViewpoint } from 'core-app/features/bim/bcf/api/bcf-api.model';
import { map } from 'rxjs/operators';

export class BcfViewpointPaths extends BcfResourcePath {
  readonly bcfViewpointsService = new BcfApiRequestService<BcfViewpoint>(this.injector);

  public readonly selection = new BcfViewpointSelectionPath(this.injector, this.path, 'selection');

  public readonly visibility = new BcfViewpointVisibilityPaths(this.injector, this.path, 'visibility');

  get(params:HTTPClientParamMap = {}, headers:HTTPClientHeaders = {}):Observable<BcfViewpoint> {
    return this.bcfViewpointsService.get(this.toPath(), params, headers);
  }

  delete(headers:HTTPClientHeaders = {}):Observable<void> {
    return this.bcfViewpointsService
      .request('delete', this.toPath(), {}, headers)
      .pipe(
        map(() => { }),
      );
  }
}
