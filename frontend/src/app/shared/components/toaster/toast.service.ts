

import { ConfigurationService } from 'core-app/core/config/configuration.service';
import {
  input,
  State,
} from 'reactivestates';
import { Injectable } from '@angular/core';
import { UploadInProgress } from 'core-app/core/file-upload/op-file-upload.service';
import {
  IHalErrorBase,
  IHalMultipleError,
} from 'core-app/features/hal/resources/error-resource';
import { HttpErrorResponse } from '@angular/common/http';

export function removeSuccessFlashMessages() {
  jQuery('.flash.notice').remove();
}

export type ToastType = 'success'|'error'|'warning'|'info'|'upload';
export const OPToastEvent = 'op:toasters:add';

export interface IToast {
  message:string;
  link?:{ text:string, target:Function };
  type:ToastType;
  data?:any;
}

@Injectable({ providedIn: 'root' })
export class ToastService {
  // The current stack of toasters
  private stack = input<IToast[]>([]);

  constructor(readonly configurationService:ConfigurationService) {
    jQuery(window)
      .on(OPToastEvent,
        (event:JQuery.TriggeredEvent, toast:IToast) => {
          this.add(toast);
        });
  }

  /**
   * Get a read-only view of the current stack of toasters.
   */
  public get current():State<IToast[]> {
    return this.stack;
  }

  public add(toast:IToast, timeoutAfter = 5000):IToast {
    // Remove flash messages
    removeSuccessFlashMessages();

    this.stack.doModify((current) => {
      const nextValue = [toast].concat(current);
      _.remove(nextValue, (n, i) => i > 0 && (n.type === 'success' || n.type === 'error'));
      return nextValue;
    });

    // auto-hide if success
    if (toast.type === 'success' && this.configurationService.autoHidePopups()) {
      setTimeout(() => this.remove(toast), timeoutAfter);
    }

    return toast;
  }

  public addError(obj:HttpErrorResponse|IToast|string, additionalErrors:unknown[]|string = []):IToast {
    let message:IToast|string;
    let errors:string[];

    if (typeof additionalErrors === 'string') {
      errors = [additionalErrors];
    } else {
      errors = [...additionalErrors] as string[];
    }

    if (obj instanceof HttpErrorResponse && (obj.error as IHalMultipleError)?._embedded?.errors) {
      errors = [
        ...errors,
        ...(obj.error as IHalMultipleError)._embedded.errors.map((el:IHalErrorBase) => el.message),
      ];
      message = obj.message;
    } else {
      message = obj as IToast|string;
    }

    const toast:IToast = this.createToast(message, 'error');
    toast.data = errors;

    return this.add(toast);
  }

  public addWarning(message:IToast|string):IToast {
    return this.add(this.createToast(message, 'warning'));
  }

  public addSuccess(message:IToast|string):IToast {
    return this.add(this.createToast(message, 'success'));
  }

  public addNotice(message:IToast|string):IToast {
    return this.add(this.createToast(message, 'info'));
  }

  public addAttachmentUpload(message:IToast|string, uploads:UploadInProgress[]):IToast {
    return this.add(this.createAttachmentUploadToast(message, uploads));
  }

  public remove(toast:IToast):void {
    this.stack.doModify((current) => {
      _.remove(current, (n) => n === toast);
      return current;
    });
  }

  public clear():void {
    this.stack.putValue([]);
  }

  private createToast(message:IToast|string, type:ToastType):IToast {
    if (typeof message === 'string') {
      return { message, type };
    }
    message.type = type;

    return message;
  }

  private createAttachmentUploadToast(message:IToast|string, uploads:UploadInProgress[]) {
    if (!uploads.length) {
      throw new Error('Cannot create an upload toast without uploads!');
    }

    const toast = this.createToast(message, 'upload');
    toast.data = uploads;

    return toast;
  }
}
