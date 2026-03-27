import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { environment } from '../../../environments/environment';
import { ProjekatRequest, ProjekatResponse } from '../models/projekat.models';

@Injectable({ providedIn: 'root' })
export class ProjekatService {
  private http = inject(HttpClient);
  private baseUrl = `${environment.apiUrl}/api/projekat/projekat`;

  getAll(): Observable<ProjekatResponse[]> {
    return this.http.get<ProjekatResponse[]>(this.baseUrl);
  }

  getById(id: number): Observable<ProjekatResponse> {
    return this.http.get<ProjekatResponse>(`${this.baseUrl}/${id}`);
  }

  create(request: ProjekatRequest): Observable<ProjekatResponse> {
    return this.http.post<ProjekatResponse>(this.baseUrl, request);
  }

  update(id: number, request: ProjekatRequest): Observable<void> {
    return this.http.put<void>(`${this.baseUrl}/${id}`, request);
  }

  delete(id: number): Observable<void> {
    return this.http.delete<void>(`${this.baseUrl}/${id}`);
  }
}
