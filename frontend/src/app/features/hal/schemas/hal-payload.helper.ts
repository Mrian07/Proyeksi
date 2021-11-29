

import { HalResource } from 'core-app/features/hal/resources/hal-resource';
import { SchemaResource } from 'core-app/features/hal/resources/schema-resource';

export class HalPayloadHelper {
  /**
   * Extract payload from the given request with schema.
   * This will ensure we will only write writable attributes and so on.
   *
   * @param resource
   * @param schema
   */
  static extractPayload<T extends HalResource = HalResource>(resource:T|Object|null, schema:SchemaResource|null = null):Object {
    if (resource instanceof HalResource && schema) {
      return this.extractPayloadFromSchema(resource, schema);
    } if (resource && !(resource instanceof HalResource)) {
      return resource;
    }
    return {};
  }

  /**
   * Extract writable payload from a HAL resource class to be used for API calls.
   *
   * The schema contains writable information about attributes, which is what this method
   * iterates in order to build the HAL-compatible object.
   *
   * @param resource A HalResource to extract payload from
   * @param schema The associated schema to determine writable state of attributes
   */
  static extractPayloadFromSchema<T extends HalResource = HalResource>(resource:T, schema:SchemaResource) {
    const payload:any = {
      _links: {},
    };

    const nonLinkProperties = [];

    for (const key in schema) {
      if (schema.hasOwnProperty(key) && schema[key] && schema[key].writable) {
        if (resource.$links[key]) {
          if (Array.isArray(resource[key])) {
            payload._links[key] = _.map(resource[key], (element) => ({ href: (element as HalResource).href }));
          } else {
            payload._links[key] = {
              href: (resource[key] && resource[key].href),
            };
          }
        } else {
          nonLinkProperties.push(key);
        }
      }
    }

    _.each(nonLinkProperties, (property) => {
      if (resource.hasOwnProperty(property) || resource[property]) {
        if (Array.isArray(resource[property])) {
          payload[property] = _.map(resource[property], (element:any) => {
            if (element instanceof HalResource) {
              return this.extractPayloadFromSchema(element, element.currentSchema || element.schema);
            }
            return element;
          });
        } else {
          payload[property] = resource[property];
        }
      }
    });

    return payload;
  }
}
