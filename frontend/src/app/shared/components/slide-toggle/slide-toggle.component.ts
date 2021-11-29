

import {
  ChangeDetectionStrategy,
  ChangeDetectorRef,
  Component,
  ElementRef,
  EventEmitter,
  Input,
  OnChanges,
  OnInit,
  Output,
  SimpleChanges,
} from '@angular/core';

export const slideToggleSelector = 'slide-toggle';

@Component({
  templateUrl: './slide-toggle.component.html',
  selector: slideToggleSelector,
  styleUrls: ['./slide-toggle.component.sass'],
  changeDetection: ChangeDetectionStrategy.OnPush,
})

export class SlideToggleComponent implements OnInit, OnChanges {
  @Input() containerId:string;

  @Input() containerClasses:string;

  @Input() inputId:string;

  @Input() inputName:string;

  @Input() active:boolean;

  @Output() valueChanged = new EventEmitter();

  constructor(private elementRef:ElementRef,
    private cdRef:ChangeDetectorRef) {
  }

  ngOnChanges(changes:SimpleChanges) {
    console.warn(JSON.stringify(changes));
  }

  ngOnInit() {
    const { dataset } = this.elementRef.nativeElement;

    // Allow taking over values from dataset (Rails)
    if (dataset.inputName) {
      this.containerId = dataset.containerId;
      this.containerClasses = dataset.containerClasses;
      this.inputId = dataset.inputId;
      this.inputName = dataset.inputName;
      this.active = dataset.active.toString() === 'true';
    }
  }

  public onValueChanged(val:any) {
    this.active = val;
    this.valueChanged.emit(val);
    this.cdRef.detectChanges();
  }
}
