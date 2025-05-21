import { Component, OnInit } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { MatCardModule } from '@angular/material/card';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';
import { MatButtonModule } from '@angular/material/button';

@Component({
  selector: 'app-settings',
  standalone: true,
  templateUrl: './settings.component.html',
  styleUrls: ['./settings.component.css'],
  imports: [
    CommonModule,
    FormsModule,
    MatCardModule,
    MatFormFieldModule,
    MatInputModule,
    MatButtonModule
  ]
})
export class SettingsComponent implements OnInit {
  studentId: string | null = null;
  profile: any = null;
  errorMsg = '';
  loading = true;

  constructor(private http: HttpClient) {}

  ngOnInit(): void {
    this.studentId = localStorage.getItem('studentId');
    if (!this.studentId) {
      this.errorMsg = 'No student ID found.';
      this.loading = false;
      return;
    }

    this.http.get(`http://localhost:3000/api/students/${this.studentId}/profile`)
      .subscribe({
        next: (res) => {
          this.profile = res;
          this.loading = false;
        },
        error: (err) => {
          console.error('Error loading profile:', err);
          this.errorMsg = 'Failed to load profile.';
          this.loading = false;
        }
      });
  }

  saveChanges(): void {
    if (!this.studentId) return;

    this.http.put(`http://localhost:3000/api/students/${this.studentId}/profile`, this.profile)
      .subscribe({
        next: () => alert('Changes saved successfully!'),
        error: (err) => {
          console.error('Save error:', err);
          alert('Failed to save changes.');
        }
      });
  }
}
