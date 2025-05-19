import { Component, HostListener, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { AuthService } from '../../services/auth.service';
import { CommonModule } from '@angular/common';
import { RouterOutlet, RouterModule } from '@angular/router';
import { MatIconModule } from '@angular/material/icon';
import { MatButtonModule } from '@angular/material/button';

@Component({
  selector: 'app-student-dashboard',
  standalone: true,
  templateUrl: './student-dashboard.component.html',
  styleUrls: ['./student-dashboard.component.css'],
  imports: [
    CommonModule,
    RouterOutlet,
    RouterModule,
    MatIconModule,
    MatButtonModule
  ]
})
export class StudentDashboardComponent implements OnInit {
  isCollapsed = false;
  student: any;

  constructor(private auth: AuthService, private router: Router) {}

  ngOnInit(): void {
    this.student = this.auth.getUser();

    if (!this.student || this.student.role !== 'student') {
      console.warn('[Dashboard] No valid student session found.');
      this.router.navigate(['/login']);
    }

    this.checkWindowSize();
  }

  @HostListener('window:resize', [])
  onResize(): void {
    this.checkWindowSize();
  }

  checkWindowSize(): void {
    this.isCollapsed = window.innerWidth <= 768;
  }

  toggleSidebar(): void {
    this.isCollapsed = !this.isCollapsed;
  }

  logout(): void {
    this.auth.logout();
    this.router.navigate(['/login']);
  }
}





// import { Component, HostListener } from '@angular/core';
// import { Router } from '@angular/router';
// import { AuthService } from '../../services/auth.service';
// import { CommonModule } from '@angular/common';
// import { RouterOutlet } from '@angular/router';
// import { MatIconModule } from '@angular/material/icon';
// import { MatButtonModule } from '@angular/material/button';
// import { RouterModule } from '@angular/router';


// @Component({
//   selector: 'app-student-dashboard',
//   standalone: true,
//   templateUrl: './student-dashboard.component.html',
//   styleUrls: ['./student-dashboard.component.css'],
//   imports: [
//     CommonModule,
//     RouterOutlet,
//     MatIconModule,
//     MatButtonModule,
//     RouterModule
//   ]
// })
// export class StudentDashboardComponent {
//   isCollapsed = false;
//   student: any;

//   constructor(private auth: AuthService, private router: Router) {}

//   ngOnInit(): void {
//     this.student = this.auth.getUser();
//     if (!this.student) {
//       this.router.navigate(['/login']);
//     }
//     this.checkWindowSize();
//   }

//   @HostListener('window:resize', [])
//   onResize() {
//     this.checkWindowSize();
//   }

//   checkWindowSize(): void {
//     this.isCollapsed = window.innerWidth <= 768; // Collapse sidebar on small screens
//   }

//   toggleSidebar(): void {
//     this.isCollapsed = !this.isCollapsed;
//   }

//   logout(): void {
//     this.auth.logout();
//     this.router.navigate(['/login']);
//   }
// }
