

import { NgModule } from '@angular/core';
import { Ng2StateDeclaration, UIRouterModule } from '@uirouter/angular';
import { OPSharedModule } from 'core-app/shared/shared.module';
import { OpenprojectModalModule } from 'core-app/shared/components/modal/modal.module';
import { OpenprojectGridsModule } from 'core-app/shared/components/grids/openproject-grids.module';
import { MyPageComponent } from 'core-app/features/my-page/my-page.component';

export const MY_PAGE_ROUTES:Ng2StateDeclaration[] = [
  {
    name: 'my_page',
    url: '/my/page',
    component: MyPageComponent,
    data: {
      bodyClasses: ['router--work-packages-my-page', 'widget-grid-layout'],
      parent: 'work-packages',
    },
  },
];

@NgModule({
  imports: [
    OPSharedModule,
    OpenprojectGridsModule,
    OpenprojectModalModule,

    // Routes for my_page
    UIRouterModule.forChild({ states: MY_PAGE_ROUTES }),
  ],
  declarations: [
    MyPageComponent,
  ],
})
export class OpenprojectMyPageModule {
}
