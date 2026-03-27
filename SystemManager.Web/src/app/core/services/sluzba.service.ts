import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { environment } from '../../../environments/environment';
import { SluzbaRequest, SluzbaResponse } from '../models/projekat.models';

@Injectable({ providedIn: 'root' })
export class SluzbaService {
  private http = inject(HttpClient);
  private baseUrl = `${environment.apiUrl}/api/projekat/sluzba`;

  getAll(): Observable<SluzbaResponse[]> {
    return this.http.get<SluzbaResponse[]>(this.baseUrl);
  }

  getById(id: number): Observable<SluzbaResponse> {
    return this.http.get<SluzbaResponse>(`${this.baseUrl}/${id}`);
  }

  create(request: SluzbaRequest): Observable<SluzbaResponse> {
    return this.http.post<SluzbaResponse>(this.baseUrl, request);
  }

  update(id: number, request: SluzbaRequest): Observable<void> {
    return this.http.put<void>(`${this.baseUrl}/${id}`, request);
  }

  delete(id: number): Observable<void> {
    return this.http.delete<void>(`${this.baseUrl}/${id}`);
  }
}
