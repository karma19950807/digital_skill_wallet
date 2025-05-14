import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';

@Injectable({ providedIn: 'root' })
export class WalletService {
  private apiUrl = 'http://localhost:3000/api/wallet';

  constructor(private http: HttpClient) {}

  submitSkillCoin(payload: any) {
    return this.http.post(`${this.apiUrl}/submit`, payload);
  }
}
