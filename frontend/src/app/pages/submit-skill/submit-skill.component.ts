import { Component } from '@angular/core';
import { WalletService } from '../../services/wallet.service';
import { HttpErrorResponse } from '@angular/common/http';
import { FormsModule } from '@angular/forms';
import { CommonModule } from '@angular/common';
import { Router } from '@angular/router';

@Component({
  selector: 'app-submit-skill',
  standalone: true,
  imports: [FormsModule, CommonModule],
  templateUrl: './submit-skill.component.html',
  styleUrls: ['./submit-skill.component.css']
})
export class SubmitSkillComponent {
  studentId = '';
  testId = '';
  gradeLevel = '';
  artefactHash = '';
  successMessage = '';
  skills = {
    logical: 0,
    analysis: 0,
    problem: 0,
    digital_tools: 0
  };

  constructor(private walletService: WalletService, private router: Router) {}

  submit() {
    const payload = {
      studentId: this.studentId,
      testId: this.testId,
      gradeLevel: this.gradeLevel,
      skills: this.skills,
      artefactHash: this.artefactHash
    };

    this.walletService.submitSkillCoin(payload).subscribe({
      next: () => {
        this.successMessage = '✅ Skill Coin submitted!';
  setTimeout(() => {
    this.router.navigate(['/dashboard']);
  }, 1500);
      },
      error: (err: HttpErrorResponse) =>
        alert(`❌ Submission failed: ${err.error?.error || err.message}`)
    });
  }
}
