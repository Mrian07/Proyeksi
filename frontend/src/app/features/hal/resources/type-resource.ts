

import { HalResource } from 'core-app/features/hal/resources/hal-resource';
import { InputState } from 'reactivestates';

export class TypeResource extends HalResource {
  public color:string;

  public get state():InputState<this> {
    return this.states.types.get(this.href as string) as any;
  }
}
