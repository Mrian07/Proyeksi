

import { NgModule } from '@angular/core';
import { UIRouterModule } from '@uirouter/angular';
import { SwaggerUIComponent } from './swagger-ui/swagger-ui.component';
import { API_DOCS_ROUTES } from './openproject-api-docs.routes';

@NgModule({
  imports: [
    // Routes for /backlogs
    UIRouterModule.forChild({
      states: API_DOCS_ROUTES,
    }),
  ],
  declarations: [
    SwaggerUIComponent,
  ],
})
export class OpenprojectApiDocsModule {
}
