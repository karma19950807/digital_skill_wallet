import { Routes } from '@angular/router';
import { LoginComponent } from './pages/login/login.component';
import { ForbiddenComponent } from './pages/forbidden/forbidden.component';
import { AuthGuard } from './guards/auth.guard';


export const routes: Routes = [
  { path: '', redirectTo: 'login', pathMatch: 'full' },
  { path: 'login', component: LoginComponent },
  {
    path: 'student-dashboard',
    loadComponent: () => import('./pages/student-dashboard/student-dashboard.component')
      .then(m => m.StudentDashboardComponent), canActivate: [AuthGuard],
    children: [
      { path: '', redirectTo: 'overview', pathMatch:'full' },
      {
        path: 'overview',
        loadComponent: () =>
          import('./pages/student-overview/student-overview.component').then(m => m.StudentOverviewComponent),
        canActivate: [AuthGuard]
      },
      {
        path: 'tests',
        loadComponent: () =>
          import('./pages/tests/tests.component').then(m => m.TestsComponent),
        canActivate: [AuthGuard]
      },
      {
        path: 'skill-wallet',
        loadComponent: () =>
          import('./pages/skill-wallet/skill-wallet.component').then(m => m.SkillWalletComponent),
        canActivate: [AuthGuard]
      },
      {
        path: 'settings',
        loadComponent: () =>
          import('./pages/settings/settings.component').then(m => m.SettingsComponent),
        canActivate: [AuthGuard]
      },
    ]
  },
  

  {
    path: 'school-dashboard',
    loadComponent: () => import('./pages/school-dashboard/school-dashboard.component')
      .then(m => m.SchoolDashboardComponent)
  },

   {
    path: 'school-tests',
    loadComponent: () =>
      import('./pages/school-tests/school-tests.component').then(m => m.SchoolTestsComponent),
    canActivate: [AuthGuard]
  },
  {
    path: 'school-skill-wallet',
    loadComponent: () =>
      import('./pages/school-skill-wallet/school-skill-wallet.component').then(m => m.SchoolSkillWalletComponent),
    canActivate: [AuthGuard]
  },
  {
    path: 'school-settings',
    loadComponent: () =>
      import('./pages/school-settings/school-settings.component').then(m => m.SchoolSettingsComponent),
    canActivate: [AuthGuard]
  },

  { path: 'forbidden', component: ForbiddenComponent }
];