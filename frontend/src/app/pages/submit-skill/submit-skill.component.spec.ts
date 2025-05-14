import { ComponentFixture, TestBed } from '@angular/core/testing';

import { SubmitSkillComponent } from './submit-skill.component';

describe('SubmitSkillComponent', () => {
  let component: SubmitSkillComponent;
  let fixture: ComponentFixture<SubmitSkillComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [SubmitSkillComponent]
    })
    .compileComponents();

    fixture = TestBed.createComponent(SubmitSkillComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
