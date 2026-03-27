import { Component, inject, ChangeDetectionStrategy, signal, OnInit } from '@angular/core';
import { RouterLink } from '@angular/router';
import { MatCardModule } from '@angular/material/card';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';
import { ConfigService } from '../../core/services/config.service';

@Component({
  selector: 'app-home',
  standalone: true,
  imports: [RouterLink, MatCardModule, MatButtonModule, MatIconModule],
  changeDetection: ChangeDetectionStrategy.OnPush,
  template: `
    <div class="home-container">
      <h1>System Manager</h1>
      <p class="subtitle">Izaberite sistem za upravljanje</p>
      <div class="cards">
        <mat-card class="subsystem-card" routerLink="/ispit/zvanje">
          <mat-card-content>
            <mat-icon class="card-icon">school</mat-icon>
            <h2>ISPIT</h2>
            <p>Upravljanje ispitima</p>
          </mat-card-content>
        </mat-card>

        <mat-card class="subsystem-card" routerLink="/projekat/radnomesto">
          <mat-card-content>
            <mat-icon class="card-icon">work</mat-icon>
            <h2>PROJEKAT</h2>
            <p>Upravljanje projektima</p>
          </mat-card-content>
        </mat-card>
      </div>
      @if (provider()) {
        <p class="db-badge">Aktivna baza: {{ provider() }}</p>
      }
    </div>
  `,
  styles: [`
    .home-container {
      display: flex;
      flex-direction: column;
      align-items: center;
      padding: 64px 24px;
    }
    h1 {
      font-size: 2rem;
      margin-bottom: 8px;
    }
    .subtitle {
      color: #666;
      margin-bottom: 40px;
    }
    .cards {
      display: flex;
      gap: 32px;
      flex-wrap: wrap;
      justify-content: center;
    }
    .subsystem-card {
      width: 280px;
      cursor: pointer;
      text-align: center;
      transition: box-shadow 0.2s;
    }
    .subsystem-card:hover {
      box-shadow: 0 8px 24px rgba(0,0,0,0.15);
    }
    .card-icon {
      font-size: 56px;
      width: 56px;
      height: 56px;
      margin: 16px auto 12px;
      display: block;
    }
    mat-card-content h2 {
      font-size: 1.4rem;
      margin-bottom: 8px;
    }
    mat-card-content p {
      color: #666;
    }
    .db-badge {
      margin-top: 32px;
      font-size: 0.8rem;
      color: #999;
    }
  `]
})
export class HomeComponent implements OnInit {
  private configService = inject(ConfigService);
  provider = signal<string | null>(null);

  ngOnInit() {
    this.configService.getConfig().subscribe({
      next: (cfg) => this.provider.set(cfg.provider),
      error: () => {}
    });
  }
}
