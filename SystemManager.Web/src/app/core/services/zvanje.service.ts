import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { environment } from '../../../environments/environment';
import { ZvanjeRequest, ZvanjeResponse } from '../models/ispit.models';

@Injectable({ providedIn: 'root' })
export class ZvanjeService {
  private http = inject(HttpClient);
  private baseUrl = `${environment.apiUrl}/api/ispit/zvanje`;

  getAll(): Observable<ZvanjeResponse[]> {
    return this.http.get<ZvanjeResponse[]>(this.baseUrl);
  }

  getById(id: number): Observable<ZvanjeResponse> {
    return this.http.get<ZvanjeResponse>(`${this.baseUrl}/${id}`);
  }

  create(request: ZvanjeRequest): Observable<ZvanjeResponse> {
    return this.http.post<ZvanjeResponse>(this.baseUrl, request);
  }

  update(id: number, request: ZvanjeRequest): Observable<void> {
    return this.http.put<void>(`${this.baseUrl}/${id}`, request);
  }

  delete(id: number): Observable<void> {
    return this.http.delete<void>(`${this.baseUrl}/${id}`);
  }
}
