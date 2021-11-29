

import { BcfResourcePath } from 'core-app/features/bim/bcf/api/bcf-path-resources';
import { BcfApiRequestService } from 'core-app/features/bim/bcf/api/bcf-api-request.service';
import { HTTPClientHeaders, HTTPClientParamMap } from 'core-app/features/hal/http/http.interfaces';
import { Observable } from 'rxjs';
import { BcfViewpointSelection } from 'core-app/features/bim/bcf/api/bcf-api.model';

export class BcfViewpointSelectionPath extends BcfResourcePath {
  readonly bcfViewpointsService = new BcfApiRequestService<BcfViewpointSelection>(this.injector);

  get(params:HTTPClientParamMap = {}, headers:HTTPClientHeaders = {}):Observable<BcfViewpointSelection> {
    return this.bcfViewpointsService.get(this.toPath(), params, headers);
  }
}
