

import { Ng2StateDeclaration } from '@uirouter/angular';
import { SwaggerUIComponent } from './swagger-ui/swagger-ui.component';

export const API_DOCS_ROUTES:Ng2StateDeclaration[] = [
  {
    name: 'api-docs',
    parent: 'optional_project',
    url: '/api/docs',
    component: SwaggerUIComponent,
  },
];
