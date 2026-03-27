import { Routes } from '@angular/router';

export const routes: Routes = [
  {
    path: '',
    loadComponent: () => import('./features/home/home.component').then(m => m.HomeComponent)
  },
  {
    path: 'ispit',
    loadChildren: () => import('./features/ispit/ispit.routes').then(m => m.ispitRoutes)
  },
  {
    path: 'projekat',
    loadChildren: () => import('./features/projekat/projekat.routes').then(m => m.projekatRoutes)
  }
];
