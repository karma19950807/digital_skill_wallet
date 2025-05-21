import { Component, HostListener, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { CommonModule } from '@angular/common';
import { RouterModule, RouterOutlet } from '@angular/router';
import { MatIconModule } from '@angular/material/icon';
import { MatButtonModule } from '@angular/material/button';
import { AuthService } from '../../services/auth.service';

@Component({
  selector: 'app-school-dashboard',
  standalone: true,
  templateUrl: './school-dashboard.component.html',
  styleUrls: ['./school-dashboard.component.css'],
  imports: [
    CommonModule,
    RouterOutlet,
    RouterModule,
    MatIconModule,
    MatButtonModule
  ]
})
export class SchoolDashboardComponent implements OnInit {
  isCollapsed = false;
  school: any;

  constructor(private auth: AuthService, private router: Router) {}

  ngOnInit(): void {
    this.school = this.auth.getUser();
    if (!this.school || this.school.role !== 'school') {
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
