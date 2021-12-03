import { Injector, NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { HookService } from 'core-app/features/plugins/hook-service';
import { AvatarUploadFormComponent } from './avatar-upload-form/avatar-upload-form.component';

@NgModule({
  imports: [
    CommonModule,
  ],
  declarations: [
    AvatarUploadFormComponent,
  ],
})
export class PluginModule {
  constructor(injector:Injector) {
    const hookService = injector.get(HookService);
    hookService.register('proyeksiApptAngularBootstrap', () => [
      { selector: 'avatar-upload-form', cls: AvatarUploadFormComponent },
    ]);
  }
}
