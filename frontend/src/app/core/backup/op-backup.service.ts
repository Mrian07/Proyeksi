

import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { HalResource } from 'core-app/features/hal/resources/hal-resource';
import { Observable } from 'rxjs';
import { HalResourceService } from 'core-app/features/hal/services/hal-resource.service';

@Injectable({ providedIn: 'root' })
export class ProyeksiAppBackupService {
  constructor(protected http:HttpClient,
    protected halResource:HalResourceService) {
  }

  public triggerBackup(backupToken:string, includeAttachments = true):Observable<HalResource> {
    return this
      .http
      .request<HalResource>(
      'post',
      '/api/v3/backups',
      {
        body: { backupToken, attachments: includeAttachments },
        withCredentials: true,
        responseType: 'json' as any,
      },
    );
  }
}
