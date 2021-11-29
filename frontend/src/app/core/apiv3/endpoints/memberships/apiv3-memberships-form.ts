

import { APIv3FormResource } from 'core-app/core/apiv3/forms/apiv3-form-resource';
import { MembershipResourceEmbedded } from 'core-app/features/hal/resources/membership-resource';

export class Apiv3MembershipsForm extends APIv3FormResource {
  /**
   * We need to override the grid widget extraction
   * to pass the correct payload to the API.
   *
   * @param resource
   * @param schema
   */
  public static extractPayload(resource:MembershipResourceEmbedded):Object {
    return {
      _links: {
        project: { href: resource.project.href },
        principal: { href: resource.principal.href },
        roles: resource.roles.map((role) => ({ href: role.href })),
      },
      _meta: {
        notificationMessage: {
          raw: resource.notificationMessage.raw,
        },
      },
    };
  }

  /**
   * Extract payload for the form from the request and optional schema.
   *
   * @param request
   * @param schema
   */
  public extractPayload(request:MembershipResourceEmbedded) {
    return Apiv3MembershipsForm.extractPayload(request);
  }
}
