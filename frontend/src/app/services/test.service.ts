import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class TestService {
  private baseUrl = 'http://localhost:3000/api/tests';

  constructor(private http: HttpClient) {}

  getTestsByStudentId(studentId: string): Observable<any[]> {
    return this.http.get<any[]>(`${this.baseUrl}/${studentId}`);
  }
}
