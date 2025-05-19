import { Component, OnInit } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { CommonModule } from '@angular/common';
import { MatTableModule } from '@angular/material/table';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';
import { MatSelectModule } from '@angular/material/select';
import { FormsModule } from '@angular/forms';
import { AuthService } from '../../services/auth.service';
import { TestService } from '../../services/test.service';
import { ParseArtefactPipe } from '../../pipes/parse-artefact.pipe'; 
import { NgFor, NgIf } from '@angular/common';


@Component({
  standalone: true,
  selector: 'app-tests',
  imports: [
    CommonModule,
    MatTableModule,
    MatFormFieldModule,
    MatInputModule,
    MatSelectModule,
    FormsModule,
    NgFor,
    NgIf,
    ParseArtefactPipe
  ],
  templateUrl: './tests.component.html',
  styleUrls: ['./tests.component.css']
})

export class TestsComponent implements OnInit {
  allTests: any[] = [];
  filteredTests: any[] = [];
  selectedGrade = 'all';
  loading = true;

  constructor(private testService: TestService) {}

  ngOnInit(): void {
    const studentId = localStorage.getItem('studentId');
    if (studentId) {
      this.testService.getTestsByStudentId(studentId).subscribe({
        next: (data) => {
          console.log('Fetched data:', data);
          this.allTests = data;
          this.filteredTests = [...data];
          this.loading = false;
        },
        error: (err) => {
          console.error('Failed to fetch tests:', err);
          this.loading = false;
        }
      });
    } else {
      console.warn('No studentId found in localStorage.');
      this.loading = false;
    }
  }

  filterByGrade(): void {
    if (this.selectedGrade === 'all') {
      this.filteredTests = [...this.allTests];
    } else {
      this.filteredTests = this.allTests.filter(
        test => test.grade_level == +this.selectedGrade
      );
    }
  }

  getAverageScore(field: string): number {
    if (!this.filteredTests.length) return 0;
    const total = this.filteredTests.reduce((sum, test) => sum + (test[field] || 0), 0);
    return Math.round(total / this.filteredTests.length);
  }
}