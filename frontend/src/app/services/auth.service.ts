import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

@Injectable({ providedIn: 'root' })
export class AuthService {
  private apiUrl = 'http://localhost:3000/api/auth';

  constructor(private http: HttpClient) {}

  // Updated to accept credentials object
  login(credentials: { email: string; password: string }): Observable<any> {
  return this.http.post(`${this.apiUrl}/login`, credentials);
}


  // Store user data in localStorage after login
  setUser(user: any) {
    localStorage.setItem('user', JSON.stringify(user));
  }

  // Get logged-in user data
  getUser(): any {
    const user = localStorage.getItem('user');
    return user ? JSON.parse(user) : null;
  }

  // Check login status
  isLoggedIn(): boolean {
    return localStorage.getItem('user') !== null;
  }

  // Clear session on logout
  logout() {
    localStorage.removeItem('user');
  }
}
