

import { Injectable, Injector } from '@angular/core';
import { BehaviorSubject, Observable, Subject } from 'rxjs';
import {
  distinctUntilChanged, filter, first, map,
} from 'rxjs/operators';
import { ViewerBridgeService } from 'core-app/features/bim/bcf/bcf-viewer-bridge/viewer-bridge.service';
import { WorkPackageResource } from 'core-app/features/hal/resources/work-package-resource';
import { ViewpointsService } from 'core-app/features/bim/bcf/helper/viewpoints.service';
import { InjectField } from 'core-app/shared/helpers/angular/inject-field.decorator';
import { BcfViewpointData, CreateBcfViewpointData } from 'core-app/features/bim/bcf/api/bcf-api.model';

declare global {
  interface Window {
    RevitBridge:{
      sendMessageToRevit:(messageType:string, trackingId:string, payload:string) => void,
      sendMessageToProyeksiApp:(message:string) => void
    };
  }
}

type RevitBridgeMessage = {
  messageType:string,
  trackingId:string,
  messagePayload:CreateBcfViewpointData
};

@Injectable()
export class RevitBridgeService extends ViewerBridgeService {
  public shouldShowViewer = false;

  public viewerVisible$ = new BehaviorSubject<boolean>(false);

  private revitMessageReceivedSource = new Subject<RevitBridgeMessage>();

  private trackingIdNumber = 0;

  @InjectField() viewpointsService:ViewpointsService;

  revitMessageReceived$ = this.revitMessageReceivedSource.asObservable();

  constructor(readonly injector:Injector) {
    super(injector);

    if (window.RevitBridge) {
      this.hookUpRevitListener();
    } else {
      window.addEventListener('revit.plugin.ready', () => {
        this.hookUpRevitListener();
      }, { once: true });
    }
  }

  public viewerVisible():boolean {
    return this.viewerVisible$.getValue();
  }

  public getViewpoint$():Observable<CreateBcfViewpointData> {
    const trackingId = this.newTrackingId();

    this.sendMessageToRevit('ViewpointGenerationRequest', trackingId, '');

    return this.revitMessageReceived$
      .pipe(
        distinctUntilChanged(),
        filter((message) => message.messageType === 'ViewpointData' && message.trackingId === trackingId),
        first(),
        map((message) => {
          // FIXME: Deprecated code
          // the handling of the message payload is only needed to be compatible to the revit add-in <= 2.3.2. In
          // newer versions the message payload is sent correctly and needs no special treatment
          const viewpointJson = message.messagePayload;

          if (viewpointJson.snapshot.hasOwnProperty('snapshot_type') // eslint-disable-line no-prototype-builtins
            && viewpointJson.snapshot.hasOwnProperty('snapshot_data')) { // eslint-disable-line no-prototype-builtins
            // already correctly formatted payload
            return viewpointJson;
          }

          // at this point snapshot data should be sent as a base64 string
          viewpointJson.snapshot = {
            snapshot_type: 'png',
            snapshot_data: viewpointJson.snapshot as unknown as string,
          };

          return viewpointJson;
        }),
      );
  }

  public showViewpoint(workPackage:WorkPackageResource, index:number):void {
    this.viewpointsService
      .getViewPoint$(workPackage, index)
      .subscribe((viewpoint:BcfViewpointData) => this.sendMessageToRevit(
        'ShowViewpoint', this.newTrackingId(), JSON.stringify(viewpoint),
      ));
  }

  sendMessageToRevit(messageType:string, trackingId:string, messagePayload:string):void {
    if (!this.viewerVisible()) {
      return;
    }

    window.RevitBridge.sendMessageToRevit(messageType, trackingId, messagePayload);
  }

  private hookUpRevitListener() {
    window.RevitBridge.sendMessageToProyeksiApp = (messageString:string) => {
      const { messageType, trackingId, messagePayload } = JSON.parse(messageString) as {
        messageType:string,
        trackingId:string,
        messagePayload:string
      };

      this.revitMessageReceivedSource.next({
        messageType,
        trackingId,
        messagePayload: JSON.parse(messagePayload) as CreateBcfViewpointData,
      });
    };
    this.viewerVisible$.next(true);
  }

  newTrackingId():string {
    this.trackingIdNumber += 1;
    return String(this.trackingIdNumber);
  }
}
