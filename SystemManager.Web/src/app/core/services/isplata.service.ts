import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { environment } from '../../../environments/environment';
import { IsplataRequest, IsplataResponse } from '../models/projekat.models';

@Injectable({ providedIn: 'root' })
export class IsplataService {
  private http = inject(HttpClient);
  private baseUrl = `${environment.apiUrl}/api/projekat/radnik`;

  getAllByRadnik(radnikId: number): Observable<IsplataResponse[]> {
    return this.http.get<IsplataResponse[]>(`${this.baseUrl}/${radnikId}/isplate`);
  }

  create(radnikId: number, request: IsplataRequest): Observable<IsplataResponse> {
    return this.http.post<IsplataResponse>(`${this.baseUrl}/${radnikId}/isplate`, request);
  }

  update(radnikId: number, isplataId: number, request: IsplataRequest): Observable<void> {
    return this.http.put<void>(`${this.baseUrl}/${radnikId}/isplate/${isplataId}`, request);
  }

  delete(radnikId: number, isplataId: number): Observable<void> {
    return this.http.delete<void>(`${this.baseUrl}/${radnikId}/isplate/${isplataId}`);
  }
}
