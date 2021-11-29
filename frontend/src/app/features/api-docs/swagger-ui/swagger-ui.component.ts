

import { AfterViewInit, Component, ViewEncapsulation } from '@angular/core';
import { PathHelperService } from 'core-app/core/path-helper/path-helper.service';
import * as SwaggerUI from 'swagger-ui';

@Component({
  selector: 'op-api-docs',
  styleUrls: ['./swagger-ui.component.sass'],
  templateUrl: './swagger-ui.component.html',
  encapsulation: ViewEncapsulation.None,
})
export class SwaggerUIComponent implements AfterViewInit {
  constructor(private pathHelperService:PathHelperService) {
  }

  ngAfterViewInit() {
    SwaggerUI({
      dom_id: '#swagger',
      url: this.pathHelperService.api.v3.openApiSpecPath,
      filter: true,
      requestInterceptor: (req) => {
        if (!req.loadSpec) {
          // required to make session-based authentication work for POST requests with APIv3
          req.headers['X-Requested-With'] = 'XMLHttpRequest';
        }
        return req;
      },
    });
  }
}
