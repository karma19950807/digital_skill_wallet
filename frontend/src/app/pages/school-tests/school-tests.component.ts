import { Component, OnInit } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { CommonModule } from '@angular/common';
import { MatTableModule } from '@angular/material/table';
import { MatCardModule } from '@angular/material/card';
import { MatSelectModule } from '@angular/material/select';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatButtonModule } from '@angular/material/button';

interface TestScore {
  name: string;
  test_id: string;
  grade_level: number;
  logical_thinking: number;
  critical_analysis: number;
  problem_solving: number;
  digital_tools: number;
  is_ready: boolean;
  timestamp: string;
}

@Component({
  selector: 'app-school-tests',
  standalone: true,
  templateUrl: './school-tests.component.html',
  styleUrls: ['./school-tests.component.css'],
  imports: [
    CommonModule,
    MatCardModule,
    MatTableModule,
    MatFormFieldModule,
    MatSelectModule,
    MatButtonModule
  ]
})
export class SchoolTestsComponent implements OnInit {
  schoolId: string | null = null;
  tests: TestScore[] = [];
  filteredTests: TestScore[] = [];
  selectedGrade: string = 'all';
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

    this.http.get<TestScore[]>(`http://localhost:3000/api/schools/${this.schoolId}/tests`)
      .subscribe({
        next: (res) => {
          this.tests = res;
          this.filteredTests = res;
          this.loading = false;
        },
        error: (err) => {
          console.error('Error fetching test scores:', err);
          this.errorMsg = 'Failed to load test scores';
          this.loading = false;
        }
      });
  }

  filterByGrade(): void {
    if (this.selectedGrade === 'all') {
      this.filteredTests = this.tests;
    } else {
      const grade = parseInt(this.selectedGrade);
      this.filteredTests = this.tests.filter(t => t.grade_level === grade);
    }
  }
}
