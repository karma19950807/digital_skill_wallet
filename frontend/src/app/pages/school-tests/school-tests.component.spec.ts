import { ComponentFixture, TestBed } from '@angular/core/testing';

import { SchoolTestsComponent } from './school-tests.component';

describe('SchoolTestsComponent', () => {
  let component: SchoolTestsComponent;
  let fixture: ComponentFixture<SchoolTestsComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [SchoolTestsComponent]
    })
    .compileComponents();

    fixture = TestBed.createComponent(SchoolTestsComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
