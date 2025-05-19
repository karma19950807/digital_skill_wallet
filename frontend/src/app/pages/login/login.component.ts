import { Component } from '@angular/core';
import { Router } from '@angular/router';
import { AuthService } from '../../services/auth.service';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { MatCardModule } from '@angular/material/card';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';
import { MatButtonModule } from '@angular/material/button';

@Component({
  standalone: true,
  selector: 'app-login',
  imports: [CommonModule, FormsModule, MatCardModule, MatFormFieldModule, MatInputModule, MatButtonModule],
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.css']
})
export class LoginComponent {
  email = '';
  password = '';
  errorMsg = '';

  constructor(private auth: AuthService, private router: Router) {}

  onLogin(): void {
    this.auth.login({ email: this.email, password: this.password }).subscribe({
      next: (res) => {
        console.log('[LoginComponent] login response:', res);
        this.auth.setUser(res);

        if (res.role === 'student') this.router.navigateByUrl('/student-dashboard');
        else if (res.role === 'school') this.router.navigateByUrl('/school-dashboard');
        else this.errorMsg = 'Unknown user role.';
      },
      error: (err) => {
        console.error('[LoginComponent] login failed:', err);
        this.errorMsg = err.error?.error || 'Login failed. Try again.';
      }
    });
  }



  // onLogin(): void {
  //   this.auth.login({ email: this.email, password: this.password }).subscribe({
  //     next: (res) => {
  //       if (!res?.role) {
  //         this.errorMsg = 'Missing role in response';
  //         return;
  //       }

  //       localStorage.setItem('token', res.token);
  //       localStorage.setItem('role', res.role);
  //       localStorage.setItem('userId', res.user_id);

  //       if (res.role === 'student' && res.student_id) {
  //         localStorage.setItem('studentId', res.student_id);
  //         this.router.navigateByUrl('/student-dashboard');
  //       } else if (res.role === 'school' && res.school_id) {
  //         localStorage.setItem('schoolId', res.school_id);
  //         this.router.navigateByUrl('/school-dashboard');
  //       } else {
  //         this.errorMsg = 'Unable to identify user type';
  //       }
  //     },
  //     error: (err) => {
  //       console.error('Login error:', err);
  //       this.errorMsg = err.error?.error || 'Login failed';
  //     }
  //   });
  // }

  forgotPassword(event: Event): void {
    event.preventDefault();
    alert('Forgot Password page (TBD)');
  }
}