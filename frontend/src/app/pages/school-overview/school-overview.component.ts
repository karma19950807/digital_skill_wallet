// File: src/app/pages/school-overview/school-overview.component.ts
import { Component, OnInit } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { ChartConfiguration } from 'chart.js';
import { CommonModule } from '@angular/common';
import { NgChartsModule } from 'ng2-charts';
import { MatCardModule } from '@angular/material/card';
import { MatSelectModule } from '@angular/material/select';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatButtonModule } from '@angular/material/button';

interface SubmissionItem {
  name: string;
  test_id: string;
  status: string;
  timestamp: string;
}

@Component({
  selector: 'app-school-overview',
  standalone: true,
  templateUrl: './school-overview.component.html',
  styleUrls: ['./school-overview.component.css'],
  imports: [
    CommonModule,
    NgChartsModule,
    MatCardModule,
    MatSelectModule,
    MatFormFieldModule,
    MatButtonModule
  ]
})
export class SchoolOverviewComponent implements OnInit {
  schoolId: string | null = null;
  stats: any = null;
  filteredSubmissions: SubmissionItem[] = [];
  loading = true;
  errorMsg = '';

  gradeChart: ChartConfiguration<'bar'>['data'] = { labels: [], datasets: [] };
  statusChart: ChartConfiguration<'pie'>['data'] = { labels: [], datasets: [] };

  sortKey: string = '';
  sortAsc: boolean = true;
  selectedRange: string = 'all';

  constructor(private http: HttpClient) {}

  ngOnInit(): void {
    this.schoolId = localStorage.getItem('schoolId');
    if (!this.schoolId) {
      this.errorMsg = 'No school ID found.';
      this.loading = false;
      return;
    }

    this.http.get(`http://localhost:3000/api/schools/${this.schoolId}/overview`)  
      .subscribe({
        next: (res: any) => {
          this.stats = res;
          this.filteredSubmissions = [...res.recentSubmissions];
          this.setupCharts(res);
          this.loading = false;
        },
        error: (err) => {
          console.error('Error loading dashboard:', err);
          this.errorMsg = 'Failed to load school overview.';
          this.loading = false;
        }
      });
  }

  setupCharts(res: any): void {
    this.gradeChart = {
      labels: Object.keys(res.submissionsByGrade),
      datasets: [
        {
          label: 'Submissions by Grade',
          data: Object.values(res.submissionsByGrade),
          backgroundColor: '#42A5F5'
        }
      ]
    };

    this.statusChart = {
      labels: Object.keys(res.skillStatusCounts),
      datasets: [
        {
          label: 'Skill Records',
          data: Object.values(res.skillStatusCounts),
          backgroundColor: ['#FFA726', '#66BB6A', '#EF5350', '#AB47BC']
        }
      ]
    };
  }

  sortTable(key: keyof SubmissionItem): void {
    if (this.sortKey === key) {
      this.sortAsc = !this.sortAsc;
    } else {
      this.sortKey = key;
      this.sortAsc = true;
    }

    this.filteredSubmissions.sort((a, b) => {
      const aVal = a[key];
      const bVal = b[key];
      if (aVal < bVal) return this.sortAsc ? -1 : 1;
      if (aVal > bVal) return this.sortAsc ? 1 : -1;
      return 0;
    });
  }

  filterByDate(): void {
    const now = new Date();
    if (this.selectedRange === 'all') {
      this.filteredSubmissions = [...this.stats.recentSubmissions];
      return;
    }

    const days = parseInt(this.selectedRange);
    const cutoff = new Date();
    cutoff.setDate(now.getDate() - days);

    this.filteredSubmissions = this.stats.recentSubmissions.filter((item: SubmissionItem) => {
      return new Date(item.timestamp) >= cutoff;
    });
  }

  downloadCSV(): void {
    const header = ['Student', 'Test ID', 'Status', 'Date'];
    const rows = this.filteredSubmissions.map(s => [
      s.name, s.test_id, s.status, new Date(s.timestamp).toLocaleString()
    ]);

    let csvContent = 'data:text/csv;charset=utf-8,';
    csvContent += header.join(',') + '\n';
    rows.forEach(row => {
      csvContent += row.join(',') + '\n';
    });

    const blob = new Blob([csvContent], { type: 'text/csv;charset=utf-8;' });
    const url = URL.createObjectURL(blob);

    const a = document.createElement('a');
    a.href = url;
    a.download = 'recent_submissions.csv';
    a.click();

    URL.revokeObjectURL(url);
  }
}
