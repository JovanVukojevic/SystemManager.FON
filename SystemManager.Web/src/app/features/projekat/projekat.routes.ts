import { Routes } from '@angular/router';

export const projekatRoutes: Routes = [
  {
    path: 'radnomesto',
    loadComponent: () => import('./radnomesto/radnomesto-list.component').then(m => m.RadnoMestoListComponent)
  },
  {
    path: 'sluzba',
    loadComponent: () => import('./sluzba/sluzba-list.component').then(m => m.SluzbaListComponent)
  },
  {
    path: 'projekat',
    loadComponent: () => import('./projekat/projekat-list.component').then(m => m.ProjekatListComponent)
  },
  {
    path: 'radnik',
    loadComponent: () => import('./radnik/radnik-list.component').then(m => m.RadnikListComponent)
  },
  {
    path: 'radnik/:id',
    loadComponent: () => import('./radnik/radnik-detail.component').then(m => m.RadnikDetailComponent)
  }
];
