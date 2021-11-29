

import { Injectable, Injector, NgZone } from '@angular/core';
import { OpModalService } from 'core-app/shared/components/modal/modal.service';
import { WpPreviewModalComponent } from 'core-app/shared/components/modals/preview-modal/wp-preview-modal/wp-preview.modal';

@Injectable({ providedIn: 'root' })
export class PreviewTriggerService {
  private previewModal:WpPreviewModalComponent;

  private modalElement:HTMLElement;

  private mouseInModal = false;

  constructor(readonly opModalService:OpModalService,
    readonly ngZone:NgZone,
    readonly injector:Injector) {
  }

  setupListener() {
    jQuery(document.body).on('mouseover', '.preview-trigger', (e) => {
      e.preventDefault();
      e.stopPropagation();
      const el = jQuery(e.target);
      const href = el.attr('href');

      if (!href) {
        return;
      }

      this.previewModal = this.opModalService.show(
        WpPreviewModalComponent,
        this.injector,
        { workPackageLink: href, event: e },
        true,
      );
      this.modalElement = this.previewModal.elementRef.nativeElement;
      this.previewModal.reposition(jQuery(this.modalElement), el);
    });

    jQuery(document.body).on('mouseleave', '.preview-trigger', () => {
      this.closeAfterTimeout();
    });

    jQuery(document.body).on('mouseleave', '.op-wp-preview-modal', () => {
      this.mouseInModal = false;
      this.closeAfterTimeout();
    });

    jQuery(document.body).on('mouseenter', '.op-wp-preview-modal', () => {
      this.mouseInModal = true;
    });
  }

  private closeAfterTimeout() {
    this.ngZone.runOutsideAngular(() => {
      setTimeout(() => {
        if (!this.mouseInModal) {
          this.opModalService.close();
        }
      }, 100);
    });
  }

  private isMouseOverPreview(e:JQuery.MouseLeaveEvent) {
    if (!this.modalElement) {
      return false;
    }

    const previewElement = jQuery(this.modalElement.children[0]);
    if (previewElement && previewElement.offset()) {
      const horizontalHover = e.pageX >= Math.floor(previewElement.offset()!.left)
        && e.pageX < previewElement.offset()!.left + previewElement.width()!;
      const verticalHover = e.pageY >= Math.floor(previewElement.offset()!.top)
        && e.pageY < previewElement.offset()!.top + previewElement.height()!;
      return horizontalHover && verticalHover;
    }
    return false;
  }
}
