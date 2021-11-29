

import {
  ApplicationRef, ComponentFactoryResolver, ComponentRef, Injectable, Injector,
} from '@angular/core';
import { DynamicBootstrapper } from 'core-app/core/setup/globals/dynamic-bootstrapper';

@Injectable()
export class CKEditorPreviewService {
  constructor(private readonly componentFactoryResolver:ComponentFactoryResolver,
    private readonly appRef:ApplicationRef,
    private readonly injector:Injector) {
  }

  /**
   * Render preview into the given element, return a remover function to disconnect all
   * dynamic components (if any).
   *
   * @param {HTMLElement} hostElement
   * @param {string} preview
   * @returns {() => void}
   */
  public render(hostElement:HTMLElement, preview:string):() => void {
    hostElement.innerHTML = preview;
    const refs:ComponentRef<any>[] = [];

    DynamicBootstrapper
      .getEmbeddable()
      .forEach((entry) => {
        const matchedElements = hostElement.querySelectorAll(entry.selector);

        for (let i = 0, l = matchedElements.length; i < l; i++) {
          const factory = this.componentFactoryResolver.resolveComponentFactory(entry.cls);
          const componentRef = factory.create(this.injector, [], matchedElements[i]);

          refs.push(componentRef);
          this.appRef.attachView(componentRef.hostView);
          componentRef.changeDetectorRef.detectChanges();
        }
      });

    return () => {
      refs.forEach((ref) => {
        this.appRef.detachView(ref.hostView);
        ref.destroy();
      });
      refs.length = 0;
      hostElement.innerHTML = '';
    };
  }
}
