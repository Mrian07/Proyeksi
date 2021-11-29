

import { NgModule } from '@angular/core';
import { OpenProjectPluginContext } from 'core-app/features/plugins/plugin-context';
import { multiInput } from 'reactivestates';
import { DocumentResource } from './hal/resources/document-resource';

export function initializeDocumentPlugin() {
  window.OpenProject.getPluginContext()
    .then((pluginContext:OpenProjectPluginContext) => {
      const halResourceService = pluginContext.services.halResource;
      halResourceService.registerResource('Document', { cls: DocumentResource });

      const { states } = pluginContext.services;
      states.add('documents', multiInput<DocumentResource>());
    });
}

@NgModule()
export class PluginModule {
  constructor() {
    initializeDocumentPlugin();
  }
}
