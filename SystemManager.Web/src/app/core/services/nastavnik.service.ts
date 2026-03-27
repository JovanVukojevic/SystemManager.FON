import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { environment } from '../../../environments/environment';
import { NastavnikRequest, NastavnikResponse } from '../models/ispit.models';

@Injectable({ providedIn: 'root' })
export class NastavnikService {
  private http = inject(HttpClient);
  private baseUrl = `${environment.apiUrl}/api/ispit/nastavnik`;

  getAll(): Observable<NastavnikResponse[]> {
    return this.http.get<NastavnikResponse[]>(this.baseUrl);
  }

  getById(id: number): Observable<NastavnikResponse> {
    return this.http.get<NastavnikResponse>(`${this.baseUrl}/${id}`);
  }

  create(request: NastavnikRequest): Observable<NastavnikResponse> {
    return this.http.post<NastavnikResponse>(this.baseUrl, request);
  }

  update(id: number, request: NastavnikRequest): Observable<void> {
    return this.http.put<void>(`${this.baseUrl}/${id}`, request);
  }

  delete(id: number): Observable<void> {
    return this.http.delete<void>(`${this.baseUrl}/${id}`);
  }
}
