
import { State } from 'reactivestates';
import { Injectable } from '@angular/core';
import { StateCacheService } from 'core-app/core/apiv3/cache/state-cache.service';
import { Observable } from 'rxjs';
import { take } from 'rxjs/operators';
import { States } from 'core-app/core/states/states.service';
import { ISchemaProxy, SchemaProxy } from 'core-app/features/hal/schemas/schema-proxy';
import { HalResourceService } from 'core-app/features/hal/services/hal-resource.service';
import { WorkPackageSchemaProxy } from 'core-app/features/hal/schemas/work-package-schema-proxy';
import { HalResource } from 'core-app/features/hal/resources/hal-resource';
import { SchemaResource } from 'core-app/features/hal/resources/schema-resource';

@Injectable()
export class SchemaCacheService extends StateCacheService<SchemaResource> {
  constructor(readonly states:States,
    readonly halResourceService:HalResourceService) {
    super(states.schemas);
  }

  public state(id:string|HalResource):State<SchemaResource> {
    return super.state(this.stateKey(id));
  }

  /**
   * Returns the schema of the provided resource.
   * This method assumes the schema is loaded and will fail if it is not.
   * @deprecated Assuming the schema to be loaded is deprecated. Rely on the states instead.
   * @param resource The HalResource for which the schema is to be returned
   * @return The schema for the HalResource
   */
  of(resource:HalResource):ISchemaProxy {
    const schema = this.state(resource).value;

    if (!schema) {
      throw new Error(`Schema for resource ${resource} was expected to be loaded but isn't.`);
    }

    if (resource._type === 'WorkPackage') {
      return WorkPackageSchemaProxy.create(schema, resource);
    }
    return SchemaProxy.create(schema, resource);
  }

  public getSchemaHref(resource:HalResource):string {
    const href = resource.$links.schema?.href;

    if (!href) {
      throw new Error(`Resource ${resource} has no schema to load.`);
    }

    return href;
  }

  /**
   * Ensure the given schema identified by its href is currently loaded.
   * @param resource The resource with a schema property or a string to the schema href.
   * @return A promise with the loaded schema.
   */
  ensureLoaded(resource:HalResource|string):Promise<SchemaResource> {
    const href = resource instanceof HalResource ? this.getSchemaHref(resource) : resource;

    return this
      .requireAndStream(href)
      .pipe(
        take(1),
      )
      .toPromise();
  }

  /**
   * Require the value to be loaded either when forced or the value is stale
   * according to the cache interval specified for this service.
   *
   * Returns an observable to the values stream of the state.
   *
   * @param id The state to require
   * @param force Load the value anyway.
   */
  public requireAndStream(href:string, force = false):Observable<SchemaResource> {
    // Refresh when stale or being forced
    if (this.stale(href) || force) {
      this.clearAndLoad(
        href,
        this.load(href),
      );
    }

    return this.state(href).values$();
  }

  /**
   * Load the associated schema for the given work package, if needed.
   */
  protected load(href:string):Observable<SchemaResource> {
    return this
      .halResourceService
      .get<SchemaResource>(href)
      .pipe(
        take(1),
      );
  }

  protected loadAll(hrefs:string[]):Promise<unknown|undefined> {
    return Promise.all(hrefs.map((href) => this.load(href)));
  }

  /**
   * Places the schema in the schema state of the resource.
   * @param resource The resource for which the schema is to be updated
   * @param schema
   */
  update(resource:HalResource, schema:SchemaResource) {
    this.multiState.get(this.stateKey(resource)).putValue(schema);
  }

  private stateKey(id:string|HalResource):string {
    if (id instanceof HalResource) {
      return this.getSchemaHref(id);
    }
    return id;
  }
}