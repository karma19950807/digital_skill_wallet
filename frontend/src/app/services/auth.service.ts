import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

@Injectable({ providedIn: 'root' })
export class AuthService {
  private apiUrl = 'http://localhost:3000/api/auth';

  constructor(private http: HttpClient) {}

  // API login call
  login(credentials: { email: string; password: string }): Observable<any> {
    return this.http.post(`${this.apiUrl}/login`, credentials);
  }

  // Save login data to localStorage
  setUser(data: any): void {
    localStorage.clear(); // clean slate before setting

    localStorage.setItem('token', data.token || '');
    localStorage.setItem('role', data.role || '');

    if (data.user_id) {
      localStorage.setItem('userId', data.user_id.toString());
    }

    if (data.role === 'student' && data.student_id) {
      localStorage.setItem('studentId', data.student_id.toString());
    }

    if (data.role === 'school' && data.school_id) {
      localStorage.setItem('schoolId', data.school_id.toString());
    }

    // Store entire user object in 'details' for optional access
    localStorage.setItem('details', JSON.stringify(data));

    console.log('[AuthService] Stored to localStorage:', {
      token: data.token,
      role: data.role,
      userId: data.user_id,
      studentId: data.student_id,
      schoolId: data.school_id
    });
  }

  // Retrieve stored user details (if needed)
  getUser(): any {
    const stored = localStorage.getItem('details');
    return stored ? JSON.parse(stored) : null;
  }

  // Check login status
  isLoggedIn(): boolean {
    return !!localStorage.getItem('token');
  }

  // Get current role
  getRole(): string | null {
    return localStorage.getItem('role');
  }

  // Logout user
  logout(): void {
    localStorage.clear();
  }
}








// import { Injectable } from '@angular/core';
// import { HttpClient } from '@angular/common/http';
// import { Observable } from 'rxjs';

// @Injectable({ providedIn: 'root' })
// export class AuthService {
//   private apiUrl = 'http://localhost:3000/api/auth';

//   constructor(private http: HttpClient) {}

//   // Call the backend login endpoint
//   login(credentials: { email: string; password: string }): Observable<any> {
//     return this.http.post(`${this.apiUrl}/login`, credentials);
//   }

//   // Save login response to localStorage
//   setUser(data: any): void {
//     localStorage.setItem('token', data.token);
//     localStorage.setItem('role', data.role);
//     localStorage.setItem('userId', data.user_id.toString());
//     localStorage.setItem('details', JSON.stringify(data.details || {}));

//     // ✅ Store studentId or schoolId for route guards / data fetching
//     if (data.role === 'student' && data.student_id) {
//       localStorage.setItem('studentId', data.student_id.toString());
//     }

//     if (data.role === 'school' && data.school_id) {
//       localStorage.setItem('schoolId', data.school_id.toString());
//     }

//     // ✅ Debug log to confirm values stored
//     console.log('AuthService: setUser() saved to localStorage:', {
//       token: data.token,
//       role: data.role,
//       userId: data.user_id,
//       studentId: data.student_id,
//       schoolId: data.school_id
//     });
//   }

//   // Retrieve full user object (details)
//   getUser(): any {
//     if (typeof window !== 'undefined') {
//       const details = localStorage.getItem('details');
//       return details ? JSON.parse(details) : null;
//     }
//     return null;
//   }

//   // Get just the role (e.g., 'student' or 'school')
//   getRole(): string | null {
//     return typeof window !== 'undefined' ? localStorage.getItem('role') : null;
//   }

//   // Simple logged-in check
//   isLoggedIn(): boolean {
//     return typeof window !== 'undefined' && localStorage.getItem('token') !== null;
//   }

//   // Clear localStorage on logout
//   logout(): void {
//     if (typeof window !== 'undefined') {
//       localStorage.removeItem('token');
//       localStorage.removeItem('role');
//       localStorage.removeItem('userId');
//       localStorage.removeItem('studentId');
//       localStorage.removeItem('schoolId');
//       localStorage.removeItem('details');
//     }
//   }
// }
