import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { environment } from '../../../environments/environment';
import { RadnoMestoRequest, RadnoMestoResponse } from '../models/projekat.models';

@Injectable({ providedIn: 'root' })
export class RadnoMestoService {
  private http = inject(HttpClient);
  private baseUrl = `${environment.apiUrl}/api/projekat/radnomesto`;

  getAll(): Observable<RadnoMestoResponse[]> {
    return this.http.get<RadnoMestoResponse[]>(this.baseUrl);
  }

  getById(id: number): Observable<RadnoMestoResponse> {
    return this.http.get<RadnoMestoResponse>(`${this.baseUrl}/${id}`);
  }

  create(request: RadnoMestoRequest): Observable<RadnoMestoResponse> {
    return this.http.post<RadnoMestoResponse>(this.baseUrl, request);
  }

  update(id: number, request: RadnoMestoRequest): Observable<void> {
    return this.http.put<void>(`${this.baseUrl}/${id}`, request);
  }

  delete(id: number): Observable<void> {
    return this.http.delete<void>(`${this.baseUrl}/${id}`);
  }
}
