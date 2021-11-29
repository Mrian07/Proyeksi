

import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { By } from '@angular/platform-browser';
import { DebugElement } from '@angular/core';
import { OpIconComponent } from './icon.component';

describe('opIcon Directive', () => {
  let app:OpIconComponent;
  let fixture:ComponentFixture<OpIconComponent>;
  let element:DebugElement;

  beforeEach(waitForAsync(() => {
    // noinspection JSIgnoredPromiseFromCall
    TestBed.configureTestingModule({
      declarations: [
        OpIconComponent,
      ],
    }).compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(OpIconComponent);
    app = fixture.debugElement.componentInstance;
    element = fixture.debugElement;

    app.iconClasses = 'icon-foobar icon-context';
    fixture.detectChanges();
  });

  describe('without a title', () => {
    it('should render an icon', () => {
      const i = element.query(By.css('i'));

      expect(i.nativeElement.tagName.toLowerCase()).toEqual('i');
      expect(i.classes['icon-foobar']).toBeTruthy();
      expect(i.classes['icon-context']).toBeTruthy();

      expect(element.query(By.css('span'))).toBeNull();
    });
  });

  describe('with a title', () => {
    beforeEach(() => {
      app.iconTitle = 'blabla';
      fixture.detectChanges();
    });

    it('should render icon and title', () => {
      const i = element.query(By.css('i'));
      const span = element.query(By.css('span'));

      expect(i.nativeElement.tagName.toLowerCase()).toEqual('i');
      expect(i.classes['icon-foobar']).toBeTruthy();
      expect(i.classes['icon-context']).toBeTruthy();

      expect(span.nativeElement.tagName.toLowerCase()).toEqual('span');
      expect(span.nativeElement.textContent).toEqual('blabla');
    });
  });
});
