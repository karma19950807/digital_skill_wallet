import { ComponentFixture, TestBed } from '@angular/core/testing';

import { SkillWalletComponent } from './skill-wallet.component';

describe('SkillWalletComponent', () => {
  let component: SkillWalletComponent;
  let fixture: ComponentFixture<SkillWalletComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [SkillWalletComponent]
    })
    .compileComponents();

    fixture = TestBed.createComponent(SkillWalletComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
