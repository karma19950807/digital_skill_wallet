import { Component, OnInit } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { ChartConfiguration } from 'chart.js';
import { CommonModule } from '@angular/common';
import { NgChartsModule } from 'ng2-charts';

@Component({
  selector: 'app-student-overview',
  standalone: true,
  templateUrl: './student-overview.component.html',
  styleUrls: ['./student-overview.component.css'],
  imports: [CommonModule, NgChartsModule]
})
export class StudentOverviewComponent implements OnInit {
  studentId: string | null = null;
  errorMsg = '';
  skills: any = null;

  barChartData: ChartConfiguration<'bar'>['data'] = { labels: [], datasets: [] };
  barChartOptions: ChartConfiguration<'bar'>['options'] = {
    responsive: true,
    maintainAspectRatio: false,
    plugins: { legend: { display: false } },
    scales: { y: { beginAtZero: true } }
  };

  pieChartData: ChartConfiguration<'pie'>['data'] = { labels: [], datasets: [] };
  pieChartOptions: ChartConfiguration<'pie'>['options'] = {
    responsive: true,
    maintainAspectRatio: false,
    plugins: { legend: { position: 'bottom' } }
  };

  constructor(private http: HttpClient) {}

  ngOnInit(): void {
    this.studentId = localStorage.getItem('studentId');
    if (!this.studentId) {
      this.errorMsg = 'No student ID found in localStorage.';
      return;
    }

    this.http.get<any[]>(`http://localhost:3000/api/students/${this.studentId}/skills`)
      .subscribe({
        next: (data) => {
          if (!data || data.length === 0) {
            this.errorMsg = 'No skill data available.';
            return;
          }

          const latest = data[data.length - 1];

          let parsedJson;
          try {
            parsedJson = typeof latest.skillcoin_json === 'string'
              ? JSON.parse(latest.skillcoin_json)
              : latest.skillcoin_json;
          } catch (err) {
            console.error('[Overview] Failed to parse skillcoin_json:', err);
            this.errorMsg = 'Invalid skill data format.';
            return;
          }

          const skillDetails = parsedJson.details || parsedJson.skills || null;
          if (!skillDetails) {
            this.errorMsg = 'No skill summary available.';
            return;
          }

          this.skills = skillDetails;

          const { logical_thinking, critical_analysis, problem_solving, digital_tools } = this.skills;

          this.barChartData = {
            labels: ['Logical Thinking', 'Critical Analysis', 'Problem Solving', 'Digital Tools'],
            datasets: [
              {
                label: 'Skill Scores',
                data: [logical_thinking, critical_analysis, problem_solving, digital_tools],
                backgroundColor: ['#42A5F5', '#66BB6A', '#FFA726', '#AB47BC']
              }
            ]
          };

          this.pieChartData = {
            labels: ['Logical Thinking', 'Critical Analysis', 'Problem Solving', 'Digital Tools'],
            datasets: [
              {
                data: [logical_thinking, critical_analysis, problem_solving, digital_tools],
                backgroundColor: ['#42A5F5', '#66BB6A', '#FFA726', '#AB47BC']
              }
            ]
          };
        },
        error: (err) => {
          console.error('[Overview] Error fetching data:', err);
          this.errorMsg = 'Failed to load skill data.';
        }
      });
  }
}
