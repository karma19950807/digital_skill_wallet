import { ComponentFixture, TestBed } from '@angular/core/testing';

import { SchoolSkillWalletComponent } from './school-skill-wallet.component';

describe('SchoolSkillWalletComponent', () => {
  let component: SchoolSkillWalletComponent;
  let fixture: ComponentFixture<SchoolSkillWalletComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [SchoolSkillWalletComponent]
    })
    .compileComponents();

    fixture = TestBed.createComponent(SchoolSkillWalletComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
