

import { APIv3FormResource } from 'core-app/core/apiv3/forms/apiv3-form-resource';
import { APIV3Service } from 'core-app/core/apiv3/api-v3.service';
import { SimpleResource } from 'core-app/core/apiv3/paths/path-resources';

export class APIv3ProjectCopyPaths extends SimpleResource {
  constructor(protected apiRoot:APIV3Service,
    public basePath:string) {
    super(basePath, 'copy');
  }

  // /api/v3/projects/:project_id/copy/form
  public readonly form = new APIv3FormResource(this.apiRoot, this.path, 'form');
}
