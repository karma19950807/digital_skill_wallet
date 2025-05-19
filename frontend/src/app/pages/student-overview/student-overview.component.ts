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

  // Bar chart data and options
  barChartData: ChartConfiguration<'bar'>['data'] = {
    labels: [],
    datasets: []
  };

  barChartOptions: ChartConfiguration<'bar'>['options'] = {
    responsive: true,
    maintainAspectRatio: false,
    plugins: {
      legend: {
        display: false
      }
    },
    scales: {
      y: {
        beginAtZero: true
      }
    }
  };

  // Pie chart data and options
  pieChartData: ChartConfiguration<'pie'>['data'] = {
    labels: [],
    datasets: []
  };

  pieChartOptions: ChartConfiguration<'pie'>['options'] = {
    responsive: true,
    maintainAspectRatio: false,
    plugins: {
      legend: {
        position: 'bottom'
      }
    }
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
          const latest = data[data.length - 1];
          const parsed = JSON.parse(latest.skillcoin_json);
          this.skills = parsed.skills;

          const { logical, analysis, problem, digital_tools } = this.skills;

          this.barChartData = {
            labels: ['Logical Thinking', 'Critical Analysis', 'Problem Solving', 'Digital Tools'],
            datasets: [
              {
                label: 'Skill Scores',
                data: [logical, analysis, problem, digital_tools],
                backgroundColor: ['#42A5F5', '#66BB6A', '#FFA726', '#AB47BC']
              }
            ]
          };

          this.pieChartData = {
            labels: ['Logical Thinking', 'Critical Analysis', 'Problem Solving', 'Digital Tools'],
            datasets: [
              {
                data: [logical, analysis, problem, digital_tools],
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






// import { Component, OnInit } from '@angular/core';
// import { HttpClient } from '@angular/common/http';
// import { CommonModule } from '@angular/common';
// import { NgIf } from '@angular/common';

// @Component({
//   selector: 'app-student-overview',
//   standalone: true,
//   templateUrl: './student-overview.component.html',
//   styleUrls: ['./student-overview.component.css'],
//   imports: [CommonModule, NgIf]
// })
// export class StudentOverviewComponent implements OnInit {
//   skills: any[] = [];
//   errorMsg = '';

//   constructor(private http: HttpClient) {}

//   ngOnInit(): void {
//     const studentId = localStorage.getItem('studentId');
// console.log('[Overview] studentId:', studentId);

// if (!studentId) {
//   this.errorMsg = 'Not logged in as student.';
//   return;
// }


//     // const studentId = localStorage.getItem('studentId');

//     // if (!studentId) {
//     //   console.warn('No studentId found in localStorage.');
//     //   this.errorMsg = 'Not logged in as student.';
//     //   return;
//     // }

//     this.http.get<any[]>(`http://localhost:3000/api/students/${studentId}/skills`)
//       .subscribe({
//         next: (data) => {
//           console.log('Skill data:', data);
//           this.skills = data;
//         },
//         error: (err) => {
//           console.error('Failed to fetch skill data', err);
//           this.errorMsg = 'Failed to load skill data.';
//         }
//       });
//   }
// }






// // import { Component, OnInit } from '@angular/core';
// // import { ChartConfiguration, ChartOptions, ChartType } from 'chart.js';
// // import { HttpClient } from '@angular/common/http';
// // import { AuthService } from '../../services/auth.service';
// // import { NgChartsModule } from 'ng2-charts'; // ✅ IMPORTANT
// // import { CommonModule } from '@angular/common';


// // @Component({
// //   selector: 'app-student-overview',
// //   standalone: true,
// //     imports: [CommonModule, NgChartsModule],

// //   templateUrl: './student-overview.component.html',
// //   styleUrls: ['./student-overview.component.css']
// // })
// // export class StudentOverviewComponent implements OnInit {
// //   student: any;
// //   skills = {
// //     logicalThinking: 0,
// //     criticalAnalysis: 0,
// //     problemSolving: 0
// //   };
// //   totalScore: number = 0;

// //   lineChartData: ChartConfiguration<'line'>['data'] = {
// //     labels: ['Test 1', 'Test 2', 'Test 3'],
// //     datasets: [
// //       {
// //         data: [60, 75, 90],
// //         label: 'Skill Growth',
// //         fill: true,
// //         borderColor: '#42a5f5',
// //         backgroundColor: 'rgba(66,165,245,0.3)',
// //         tension: 0.3,
// //         pointRadius: 5,
// //         pointHoverRadius: 7
// //       }
// //     ]
// //   };

// //   pieChartData: ChartConfiguration<'pie'>['data'] = {
// //     labels: ['Logical Thinking', 'Critical Analysis', 'Problem Solving'],
// //     datasets: [
// //       {
// //         data: [0, 0, 0],
// //         backgroundColor: ['#ffa726', '#ff7043', '#ffee58']
// //       }
// //     ]
// //   };

// //   chartOptions: ChartConfiguration['options'] = {
// //     responsive: true,
// //     maintainAspectRatio: false,
// //     plugins: {
// //       legend: {
// //         position: 'top',
// //       },
// //       tooltip: {
// //         enabled: true
// //       }
// //     }
// //   };

// //   constructor(private auth: AuthService, private http: HttpClient) {}

// //   ngOnInit(): void {
// //     this.student = this.auth.getUser();
// //     this.fetchSkillData();
// //   }

// //   fetchSkillData(): void {
// //     const studentId = this.student?.student_id;
// //     if (!studentId) return;

// //     this.http.get<any>(`http://localhost:3000/api/students/${studentId}/skills`).subscribe(
// //       (data) => {
// //         this.skills.logicalThinking = data.logical_thinking;
// //         this.skills.criticalAnalysis = data.critical_analysis;
// //         this.skills.problemSolving = data.problem_solving;

// //         this.totalScore = Math.round((data.logical_thinking + data.critical_analysis + data.problem_solving) / 3);

// //         this.pieChartData.datasets[0].data = [
// //           data.logical_thinking,
// //           data.critical_analysis,
// //           data.problem_solving
// //         ];
// //       },
// //       (err) => {
// //         console.error('Failed to fetch skill data', err);
// //       }
// //     );
// //   }
// // }