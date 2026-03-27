import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { environment } from '../../../environments/environment';
import { RadnikRequest, RadnikResponse } from '../models/projekat.models';

@Injectable({ providedIn: 'root' })
export class RadnikService {
  private http = inject(HttpClient);
  private baseUrl = `${environment.apiUrl}/api/projekat/radnik`;

  getAll(): Observable<RadnikResponse[]> {
    return this.http.get<RadnikResponse[]>(this.baseUrl);
  }

  getById(id: number): Observable<RadnikResponse> {
    return this.http.get<RadnikResponse>(`${this.baseUrl}/${id}`);
  }

  create(request: RadnikRequest): Observable<RadnikResponse> {
    return this.http.post<RadnikResponse>(this.baseUrl, request);
  }

  update(id: number, request: RadnikRequest): Observable<void> {
    return this.http.put<void>(`${this.baseUrl}/${id}`, request);
  }

  delete(id: number): Observable<void> {
    return this.http.delete<void>(`${this.baseUrl}/${id}`);
  }
}
