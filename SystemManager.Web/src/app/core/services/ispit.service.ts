import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { environment } from '../../../environments/environment';
import { IspitRequest, IspitResponse } from '../models/ispit.models';

@Injectable({ providedIn: 'root' })
export class IspitService {
  private http = inject(HttpClient);
  private baseUrl = `${environment.apiUrl}/api/ispit/ispit`;

  getAll(): Observable<IspitResponse[]> {
    return this.http.get<IspitResponse[]>(this.baseUrl);
  }

  getById(id: number): Observable<IspitResponse> {
    return this.http.get<IspitResponse>(`${this.baseUrl}/${id}`);
  }

  create(request: IspitRequest): Observable<IspitResponse> {
    return this.http.post<IspitResponse>(this.baseUrl, request);
  }

  update(id: number, request: IspitRequest): Observable<void> {
    return this.http.put<void>(`${this.baseUrl}/${id}`, request);
  }

  delete(id: number): Observable<void> {
    return this.http.delete<void>(`${this.baseUrl}/${id}`);
  }
}
