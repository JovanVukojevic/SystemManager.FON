import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { environment } from '../../../environments/environment';
import { PredmetRequest, PredmetResponse } from '../models/ispit.models';

@Injectable({ providedIn: 'root' })
export class PredmetService {
  private http = inject(HttpClient);
  private baseUrl = `${environment.apiUrl}/api/ispit/predmet`;

  getAll(): Observable<PredmetResponse[]> {
    return this.http.get<PredmetResponse[]>(this.baseUrl);
  }

  getById(id: number): Observable<PredmetResponse> {
    return this.http.get<PredmetResponse>(`${this.baseUrl}/${id}`);
  }

  create(request: PredmetRequest): Observable<PredmetResponse> {
    return this.http.post<PredmetResponse>(this.baseUrl, request);
  }

  update(id: number, request: PredmetRequest): Observable<void> {
    return this.http.put<void>(`${this.baseUrl}/${id}`, request);
  }

  delete(id: number): Observable<void> {
    return this.http.delete<void>(`${this.baseUrl}/${id}`);
  }
}
