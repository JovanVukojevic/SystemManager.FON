import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { environment } from '../../../environments/environment';
import { StudentRequest, StudentResponse } from '../models/ispit.models';

@Injectable({ providedIn: 'root' })
export class StudentService {
  private http = inject(HttpClient);
  private baseUrl = `${environment.apiUrl}/api/ispit/student`;

  private url(brojIndeksa: string): string {
    return `${this.baseUrl}/${encodeURIComponent(brojIndeksa)}`;
  }

  getAll(): Observable<StudentResponse[]> {
    return this.http.get<StudentResponse[]>(this.baseUrl);
  }

  getById(brojIndeksa: string): Observable<StudentResponse> {
    return this.http.get<StudentResponse>(this.url(brojIndeksa));
  }

  create(request: StudentRequest): Observable<StudentResponse> {
    return this.http.post<StudentResponse>(this.baseUrl, request);
  }

  update(brojIndeksa: string, request: StudentRequest): Observable<void> {
    return this.http.put<void>(this.url(brojIndeksa), request);
  }

  delete(brojIndeksa: string): Observable<void> {
    return this.http.delete<void>(this.url(brojIndeksa));
  }
}
