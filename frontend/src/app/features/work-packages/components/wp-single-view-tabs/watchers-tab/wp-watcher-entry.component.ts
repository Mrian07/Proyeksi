

import {
  ChangeDetectionStrategy,
  Component,
  Input,
  OnInit,
} from '@angular/core';
import { I18nService } from 'core-app/core/i18n/i18n.service';
import { UserResource } from 'core-app/features/hal/resources/user-resource';
import { WorkPackageWatchersTabComponent } from './watchers-tab.component';

@Component({
  templateUrl: './wp-watcher-entry.component.html',
  styleUrls: ['./wp-watcher-entry.component.sass'],
  changeDetection: ChangeDetectionStrategy.OnPush,
  selector: 'op-wp-watcher-entry',
})
export class WorkPackageWatcherEntryComponent implements OnInit {
  @Input() public watcher:UserResource;

  public text:{ remove:string };

  constructor(readonly I18n:I18nService,
    readonly panelCtrl:WorkPackageWatchersTabComponent) {
  }

  ngOnInit():void {
    this.text = {
      remove: this.I18n.t('js.label_remove_watcher', { name: this.watcher.name }),
    };
  }

  public remove():void {
    this.panelCtrl.removeWatcher(this.watcher);
  }
}
