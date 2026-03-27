import { Component, ChangeDetectionStrategy, signal, inject } from '@angular/core';
import { Router, RouterOutlet, RouterLink, RouterLinkActive, NavigationEnd } from '@angular/router';
import { MatToolbarModule } from '@angular/material/toolbar';
import { MatSidenavModule } from '@angular/material/sidenav';
import { MatListModule } from '@angular/material/list';
import { MatIconModule } from '@angular/material/icon';
import { MatButtonModule } from '@angular/material/button';
import { filter } from 'rxjs/operators';
import { takeUntilDestroyed } from '@angular/core/rxjs-interop';

@Component({
  selector: 'app-root',
  changeDetection: ChangeDetectionStrategy.OnPush,
  imports: [
    RouterOutlet,
    RouterLink,
    RouterLinkActive,
    MatToolbarModule,
    MatSidenavModule,
    MatListModule,
    MatIconModule,
    MatButtonModule
  ],
  templateUrl: './app.html',
  styleUrl: './app.scss'
})
export class App {
  activeSubsystem = signal<'ispit' | 'projekat' | null>(null);

  constructor() {
    const router = inject(Router);
    const setSubsystem = (url: string) => {
      if (url.startsWith('/ispit')) this.activeSubsystem.set('ispit');
      else if (url.startsWith('/projekat')) this.activeSubsystem.set('projekat');
      else this.activeSubsystem.set(null);
    };
    setSubsystem(router.url);
    router.events
      .pipe(filter(e => e instanceof NavigationEnd), takeUntilDestroyed())
      .subscribe((e: any) => setSubsystem(e.urlAfterRedirects));
  }
}
