

import { Injectable } from '@angular/core';
import { HttpEvent, HttpResponse } from '@angular/common/http';
import { from, Observable, of } from 'rxjs';
import { share, switchMap } from 'rxjs/operators';
import { HalResource } from 'core-app/features/hal/resources/hal-resource';
import { getType } from 'mime';
import {
  ProyeksiAppFileUploadService, UploadBlob, UploadFile, UploadInProgress,
} from './op-file-upload.service';

interface PrepareUploadResult {
  url:string;
  form:FormData;
  response:{
    _links:{
      completeUpload:{
        href:string;
      };
    };
  };
}

@Injectable()
export class ProyeksiAppDirectFileUploadService extends ProyeksiAppFileUploadService {
  /**
   * Upload a single file, get an UploadResult observable
   * @param {string} url
   * @param {UploadFile} file
   * @param {string} method
   */
  public uploadSingle(url:string, file:UploadFile|UploadBlob, method = 'post', responseType:'text'|'json' = 'text') {
    const observable = from(this.getDirectUploadFormFrom(url, file))
      .pipe(
        switchMap(this.uploadToExternal(file, method, responseType)),
        share(),
      );

    return [file, observable] as UploadInProgress;
  }

  private uploadToExternal(file:UploadFile|UploadBlob, method:string, responseType:string):(result:PrepareUploadResult) => Observable<HttpEvent<unknown>> {
    return (result) => {
      result.form.append('file', file, file.customName || file.name);

      return this.http.request<HalResource>(
        method,
        result.url,
        {
          body: result.form,
          // Observe the response, not the body
          observe: 'events',
          // This is important as the CORS policy for the bucket is * and you can't use credentals then,
          // besides we don't need them here anyway.
          withCredentials: false,
          responseType: responseType as 'json',
          // Subscribe to progress events. subscribe() will fire multiple times!
          reportProgress: true,
        },
      ).pipe(
        switchMap(this.finishUpload(result)),
      );
    };
  }

  private finishUpload(result:PrepareUploadResult):(result:HttpEvent<unknown>) => Observable<HttpEvent<unknown>> {
    return (event) => {
      if (event instanceof HttpResponse) {
        return this
          .http
          .get(
            result.response?._links?.completeUpload?.href,
            { observe: 'response' },
          );
      }

      // Return as new observable due to switchMap
      return of(event);
    };
  }

  public async getDirectUploadFormFrom(url:string, file:UploadFile|UploadBlob):Promise<PrepareUploadResult> {
    const fileName = file.customName || file.name;
    const contentType = (file.type || (fileName && getType(fileName)) || '' as string);

    const formData = new FormData();
    const metadata = {
      fileName,
      contentType,
      description: file.description,
      fileSize: file.size,
    };

    /*
     * @TODO We could calculate the MD5 hash here too and pass that.
     * The MD5 hash can be used as the `content-md5` option during the upload to S3 for instance.
     * This way S3 can verify the integrity of the file which we currently don't do.
     */

    // add the metadata object
    formData.append(
      'metadata',
      JSON.stringify(metadata),
    );

    const result = await this.http.request<HalResource>(
      'post',
      url,
      {
        body: formData,
        withCredentials: true,
        responseType: 'json',
      },
    ).toPromise();

    const form = new FormData();

    _.each(result._links.addAttachment.form_fields, (value, key) => {
      form.append(key, value);
    });

    return {
      form,
      url: result._links.addAttachment.href,
      response: result as any,
    };
  }
}
