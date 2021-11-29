

import { OpenProjectPluginContext } from 'core-app/features/plugins/plugin-context';
import { input, InputState } from 'reactivestates';
import { take } from 'rxjs/operators';
import { GlobalHelpers } from 'core-app/core/setup/globals/global-helpers';

/**
 * OpenProject instance methods
 */
export class OpenProject {
  public pluginContext:InputState<OpenProjectPluginContext> = input<OpenProjectPluginContext>();

  public helpers = new GlobalHelpers();

  /** Globally setable variable whether the page was edited */
  public pageWasEdited = false;

  /** Globally setable variable whether the page form is submitted.
   * Necessary to avoid a data loss warning on beforeunload */
  public pageIsSubmitted = false;

  /** Globally setable variable whether any of the EditFormComponent
   * contain changes.
   * Necessary to show a data loss warning on beforeunload when clicking
   * on a link out of the Angular app (ie: main side menu)
   * */
  public editFormsContainModelChanges:boolean;

  public getPluginContext():Promise<OpenProjectPluginContext> {
    return this.pluginContext
      .values$()
      .pipe(take(1))
      .toPromise();
  }

  public get urlRoot():string {
    return jQuery('meta[name=app_base_path]').attr('content') || '';
  }

  public get environment():string {
    return jQuery('meta[name=openproject_initializer]').data('environment');
  }

  public get edition():string {
    return jQuery('meta[name=openproject_initializer]').data('edition');
  }

  public get isStandardEdition():boolean {
    return this.edition === 'standard';
  }

  public get isBimEdition():boolean {
    return this.edition === 'bim';
  }

  /**
   * Guard access to reads and writes to the localstorage due to corrupted local databases
   * in Firefox happening in one larger client.
   *
   * NS_ERROR_FILE_CORRUPTED
   *
   * @param {string} key
   * @param {string} newValue
   * @returns {string | undefined}
   */
  public guardedLocalStorage(key:string, newValue?:string):string | void {
    try {
      if (newValue !== undefined) {
        window.localStorage.setItem(key, newValue);
      } else {
        const value = window.localStorage.getItem(key);
        return value === null ? undefined : value;
      }
    } catch (e) {
      console.error('Failed to access your browsers local storage. Is your local database corrupted?');
    }
  }
}

window.OpenProject = new OpenProject();
