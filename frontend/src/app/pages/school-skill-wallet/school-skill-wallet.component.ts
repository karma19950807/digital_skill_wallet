import { Component, OnInit } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { CommonModule } from '@angular/common';
import { MatCardModule } from '@angular/material/card';
import { MatTableModule } from '@angular/material/table';
import { MatSelectModule } from '@angular/material/select';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatButtonModule } from '@angular/material/button';

interface SkillWallet {
  student_id: string;
  name: string;
  test_id: string;
  grade_level: number;
  status: string;
  artefact_hash: string;
  skillcoin_json: any;
  calculatedCoins?: any;
}

@Component({
  selector: 'app-school-skill-wallet',
  standalone: true,
  templateUrl: './school-skill-wallet.component.html',
  styleUrls: ['./school-skill-wallet.component.css'],
  imports: [
    CommonModule,
    MatCardModule,
    MatTableModule,
    MatFormFieldModule,
    MatSelectModule,
    MatButtonModule
  ]
})
export class SchoolSkillWalletComponent implements OnInit {
  schoolId: string | null = null;
  allSkills: SkillWallet[] = [];
  filteredSkills: SkillWallet[] = [];
  selectedStatus: string = 'all';
  statuses = ['Verified', 'Not Verified'];
  errorMsg = '';
  loading = true;

  constructor(private http: HttpClient) {}

  ngOnInit(): void {
    this.schoolId = localStorage.getItem('schoolId');
    if (!this.schoolId) {
      this.errorMsg = 'No school ID found.';
      this.loading = false;
      return;
    }

    this.fetchSkills();
  }

  fetchSkills(): void {
    this.http.get<SkillWallet[]>(`http://localhost:3000/api/schools/${this.schoolId}/skills`)
      .subscribe({
        next: (res) => {
          this.allSkills = res;
          this.filteredSkills = res;
          this.loading = false;
        },
        error: (err) => {
          console.error('Error fetching skill wallet data:', err);
          this.errorMsg = 'Failed to load skill wallet records';
          this.loading = false;
        }
      });
  }

  filterByStatus(): void {
    if (this.selectedStatus === 'all') {
      this.filteredSkills = this.allSkills;
    } else {
      this.filteredSkills = this.allSkills.filter(s => s.status === this.selectedStatus);
    }
  }

  verifySkillCoins(student: SkillWallet): void {
    const id = student.student_id || student.skillcoin_json.student_id;
    if (!id) {
        console.warn('No student_id found for student:', student);
        return;
    }

    this.http.get<any>(`http://localhost:3000/api/students/${id}/calculate-coins`)
        .subscribe({
            next: (res) => {
                console.log('✅ Verification result:', res);
                this.fetchSkills(); // ✅ Refresh list after backend update
            },
            error: (err) => {
                console.error('Error verifying skill coins:', err);
            }
        });
}

  downloadProof(studentId: string): void {
    if (!studentId) {
        console.warn('No student ID provided for downloadProof');
        return;
    }
    window.open(`http://localhost:3000/api/students/${studentId}/proof`, '_blank');
  }

}
