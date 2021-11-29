

import { BcfResourceCollectionPath } from 'core-app/features/bim/bcf/api/bcf-path-resources';
import { BcfApiRequestService } from 'core-app/features/bim/bcf/api/bcf-api-request.service';
import { Observable } from 'rxjs';
import { BcfViewpointPaths } from 'core-app/features/bim/bcf/api/viewpoints/bcf-viewpoint.paths';
import { CreateBcfViewpointData } from 'core-app/features/bim/bcf/api/bcf-api.model';

export class BcfViewpointCollectionPath extends BcfResourceCollectionPath<BcfViewpointPaths> {
  readonly bcfViewpointService = new BcfApiRequestService<CreateBcfViewpointData>(this.injector);

  post(viewpoint:CreateBcfViewpointData):Observable<CreateBcfViewpointData> {
    return this
      .bcfViewpointService
      .request(
        'post',
        this.toPath(),
        viewpoint,
      );
  }
}
