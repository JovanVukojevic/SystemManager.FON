import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { environment } from '../../../environments/environment';

export interface ConfigResponse {
  provider: string;
}

@Injectable({ providedIn: 'root' })
export class ConfigService {
  private http = inject(HttpClient);

  getConfig(): Observable<ConfigResponse> {
    return this.http.get<ConfigResponse>(`${environment.apiUrl}/api/config`);
  }
}
