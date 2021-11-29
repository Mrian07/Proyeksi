

import { Injectable } from '@angular/core';
import { Apiv3Paths } from './apiv3-paths';

@Injectable({ providedIn: 'root' })
export class PathHelperService {
  public readonly appBasePath = window.appBasePath || '';

  public readonly api = {
    v3: new Apiv3Paths(this.appBasePath),
  };

  public get staticBase() {
    return this.appBasePath;
  }

  public attachmentDownloadPath(attachmentIdentifier:string, slug:string|undefined) {
    const path = `${this.staticBase}/attachments/${attachmentIdentifier}`;

    if (slug) {
      return `${path}/${slug}`;
    }
    return path;
  }

  public attachmentContentPath(attachmentIdentifier:number|string) {
    return `${this.staticBase}/attachments/${attachmentIdentifier}/content`;
  }

  public ifcModelsPath(projectIdentifier:string) {
    return `${this.staticBase}/projects/${projectIdentifier}/ifc_models`;
  }

  public ifcModelsNewPath(projectIdentifier:string) {
    return `${this.ifcModelsPath(projectIdentifier)}/new`;
  }

  public ifcModelsEditPath(projectIdentifier:string, modelId:number|string) {
    return `${this.ifcModelsPath(projectIdentifier)}/${modelId}/edit`;
  }

  public ifcModelsDeletePath(projectIdentifier:string, modelId:number|string) {
    return `${this.ifcModelsPath(projectIdentifier)}/${modelId}`;
  }

  public bimDetailsPath(projectIdentifier:string, workPackageId:string, viewpoint:number|string|null = null) {
    let path = `${this.projectPath(projectIdentifier)}/bcf/split/details/${workPackageId}`;

    if (viewpoint !== null) {
      path += `?query_props=%7B"t"%3A"id%3Adesc"%7D&viewpoint=${viewpoint}`;
    }

    return path;
  }

  public highlightingCssPath() {
    return `${this.staticBase}/highlighting/styles`;
  }

  public forumPath(projectIdentifier:string, forumIdentifier:string) {
    return `${this.projectForumPath(projectIdentifier)}/${forumIdentifier}`;
  }

  public keyboardShortcutsHelpPath() {
    return `${this.staticBase}/help/keyboard_shortcuts`;
  }

  public messagePath(messageIdentifier:string) {
    return `${this.staticBase}/topics/${messageIdentifier}`;
  }

  public myPagePath() {
    return `${this.staticBase}/my/page`;
  }

  public myNotificationsSettingsPath() {
    return `${this.staticBase}/my/notifications`;
  }

  public newsPath(newsId:string) {
    return `${this.staticBase}/news/${newsId}`;
  }

  public notificationsPath():string {
    return `${this.staticBase}/notifications`;
  }

  public loginPath() {
    return `${this.staticBase}/login`;
  }

  public projectsPath() {
    return `${this.staticBase}/projects`;
  }

  public projectPath(projectIdentifier:string) {
    return `${this.projectsPath()}/${projectIdentifier}`;
  }

  public projectActivityPath(projectIdentifier:string) {
    return `${this.projectPath(projectIdentifier)}/activity`;
  }

  public projectForumPath(projectIdentifier:string) {
    return `${this.projectPath(projectIdentifier)}/forums`;
  }

  public projectCalendarPath(projectId:string) {
    return `${this.projectPath(projectId)}/work_packages/calendar`;
  }

  public projectMembershipsPath(projectId:string) {
    return `${this.projectPath(projectId)}/members`;
  }

  public projectNewsPath(projectId:string) {
    return `${this.projectPath(projectId)}/news`;
  }

  public projectTimeEntriesPath(projectIdentifier:string) {
    return `${this.projectPath(projectIdentifier)}/cost_reports`;
  }

  public projectWikiPath(projectId:string) {
    return `${this.projectPath(projectId)}/wiki`;
  }

  public projectWorkPackagePath(projectId:string, wpId:string|number) {
    return `${this.projectWorkPackagesPath(projectId)}/${wpId}`;
  }

  public projectWorkPackagesPath(projectId:string) {
    return `${this.projectPath(projectId)}/work_packages`;
  }

  public projectWorkPackageNewPath(projectId:string) {
    return `${this.projectWorkPackagesPath(projectId)}/new`;
  }

  public projectBoardsPath(projectIdentifier:string|null) {
    if (projectIdentifier) {
      return `${this.projectPath(projectIdentifier)}/boards`;
    }
    return `${this.staticBase}/boards`;
  }

  public projectDashboardsPath(projectIdentifier:string) {
    return `${this.projectPath(projectIdentifier)}/dashboards`;
  }

  public timeEntriesPath(workPackageId:string|number) {
    const suffix = '/time_entries';

    if (workPackageId) {
      return this.workPackagePath(workPackageId) + suffix;
    }
    return this.staticBase + suffix; // time entries root path
  }

  public usersPath() {
    return `${this.staticBase}/users`;
  }

  public groupsPath() {
    return `${this.staticBase}/groups`;
  }

  public placeholderUsersPath() {
    return `${this.staticBase}/placeholder_users`;
  }

  public userPath(id:string|number) {
    return `${this.usersPath()}/${id}`;
  }

  public placeholderUserPath(id:string|number) {
    return `${this.placeholderUsersPath()}/${id}`;
  }

  public groupPath(id:string|number) {
    return `${this.groupsPath()}/${id}`;
  }

  public rolesPath() {
    return `${this.staticBase}/roles`;
  }

  public rolePath(id:string|number) {
    return `${this.rolesPath()}/${id}`;
  }

  public versionsPath() {
    return `${this.staticBase}/versions`;
  }

  public versionEditPath(id:string|number) {
    return `${this.staticBase}/versions/${id}/edit`;
  }

  public versionShowPath(id:string|number) {
    return `${this.staticBase}/versions/${id}`;
  }

  public workPackagesPath() {
    return `${this.staticBase}/work_packages`;
  }

  public workPackagePath(id:string|number) {
    return `${this.staticBase}/work_packages/${id}`;
  }

  public workPackageCopyPath(workPackageId:string|number) {
    return `${this.workPackagePath(workPackageId)}/copy`;
  }

  public workPackageDetailsCopyPath(projectIdentifier:string, workPackageId:string|number) {
    return `${this.projectWorkPackagesPath(projectIdentifier)}/details/${workPackageId}/copy`;
  }

  public workPackagesBulkDeletePath() {
    return `${this.workPackagesPath()}/bulk`;
  }

  public projectLevelListPath() {
    return `${this.projectsPath()}/level_list.json`;
  }

  public textFormattingHelp() {
    return `${this.staticBase}/help/text_formatting`;
  }
}