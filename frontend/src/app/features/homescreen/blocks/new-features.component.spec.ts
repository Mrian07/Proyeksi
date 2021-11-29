

import { DebugElement } from '@angular/core';

import { ComponentFixture, fakeAsync, TestBed } from '@angular/core/testing';
import { By } from '@angular/platform-browser';
import { I18nService } from 'core-app/core/i18n/i18n.service';
import { HomescreenNewFeaturesBlockComponent } from './new-features.component';

describe('shows edition-specific content', () => {
  let app:HomescreenNewFeaturesBlockComponent;
  let fixture:ComponentFixture<HomescreenNewFeaturesBlockComponent>;
  let element:DebugElement;

  beforeEach(() => {
    // noinspection JSIgnoredPromiseFromCall
    TestBed.configureTestingModule({
      declarations: [
        HomescreenNewFeaturesBlockComponent,
      ],
      providers: [I18nService],
    }).compileComponents();

    fixture = TestBed.createComponent(HomescreenNewFeaturesBlockComponent);
    app = fixture.debugElement.componentInstance;
    element = fixture.debugElement.query(By.css('div.widget-box--description p'));
  });

  it('should render bim text for bim edition', fakeAsync(() => {
    app.isStandardEdition = false;

    fixture.detectChanges();

    // checking for missing translation key as translations are not loaded in specs
    expect(element.nativeElement.textContent).toContain('.bim.new_features_html');
  }));

  it('should render standard text for standard edition', fakeAsync(() => {
    app.isStandardEdition = true;

    fixture.detectChanges();

    // checking for missing translation key as translations are not loaded in specs
    expect(element.nativeElement.textContent).toContain('.standard.new_features_html');
  }));
});
