import { Component, OnInit } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { CommonModule } from '@angular/common';
import { MatCardModule } from '@angular/material/card';
import { MatTableModule } from '@angular/material/table';
import { MatProgressSpinnerModule } from '@angular/material/progress-spinner';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatSelectModule } from '@angular/material/select';
import { MatDialogModule } from '@angular/material/dialog';

@Component({
  selector: 'app-skill-wallet',
  standalone: true,
  templateUrl: './skill-wallet.component.html',
  styleUrls: ['./skill-wallet.component.css'],
  imports: [
    CommonModule,
    MatCardModule,
    MatTableModule,
    MatProgressSpinnerModule,
    MatFormFieldModule,
    MatSelectModule,
    MatDialogModule
  ]
})
export class SkillWalletComponent implements OnInit {
  studentId: string | null = null;
  skillWallet: any[] = [];
  filteredWallet: any[] = [];
  errorMsg = '';
  loading = true;

  displayedColumns: string[] = ['test_id', 'grade_level', 'artefact_hash', 'status', 'created_at', 'view'];
  statuses: string[] = ['staged', 'endorsed', 'submitted', 'committed'];
  selectedStatus: string = '';

  modalData: any = null;

  constructor(private http: HttpClient) {}

  ngOnInit(): void {
    this.studentId = localStorage.getItem('studentId');
    if (!this.studentId) {
      this.errorMsg = 'No student ID found.';
      this.loading = false;
      return;
    }

    this.http.get<any[]>(`http://localhost:3000/api/students/${this.studentId}/skill-wallet`)
      .subscribe({
        next: (data: any[]) => {
          this.skillWallet = data;
          this.filteredWallet = [...data];
          this.loading = false;
        },
        error: (err: any) => {
          console.error('Skill Wallet fetch error:', err);
          this.errorMsg = 'Failed to load skill wallet.';
          this.loading = false;
        }
      });
  }

  filterWallet(): void {
    if (!this.selectedStatus) {
      this.filteredWallet = [...this.skillWallet];
    } else {
      this.filteredWallet = this.skillWallet.filter(row => row.status === this.selectedStatus);
    }
  }

  openSkillDetail(row: any): void {
    if (!row.skillcoin_json) return;
    try {
      this.modalData = JSON.parse(row.skillcoin_json);
      const dialog = document.getElementById('skillModal') as HTMLDialogElement;
      if (dialog) dialog.showModal();
    } catch (e) {
      console.error('Invalid JSON in skillcoin:', e);
    }
  }

  closeModal(): void {
    const dialog = document.getElementById('skillModal') as HTMLDialogElement;
    if (dialog) dialog.close();
  }
}
