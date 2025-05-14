import { Routes } from '@angular/router';
import { LoginComponent } from './pages/login/login.component';
import { StudentDashboardComponent } from './pages/student-dashboard/student-dashboard.component';
import { SchoolDashboardComponent } from './pages/school-dashboard/school-dashboard.component';
import { AuthGuard } from './guards/auth.guard';

export const routes: Routes = [
  { path: '', redirectTo: 'login', pathMatch: 'full' },
  { path: 'login', component: LoginComponent },
  {
    path: 'student-dashboard',
    component: StudentDashboardComponent,
    canActivate: [AuthGuard],
  },
  {
    path: 'school-dashboard',
    component: SchoolDashboardComponent,
    canActivate: [AuthGuard],
  },
];
