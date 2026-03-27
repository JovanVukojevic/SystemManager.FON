import { Routes } from '@angular/router';

export const ispitRoutes: Routes = [
  {
    path: 'zvanje',
    loadComponent: () => import('./zvanje/zvanje-list.component').then(m => m.ZvanjeListComponent)
  },
  {
    path: 'predmet',
    loadComponent: () => import('./predmet/predmet-list.component').then(m => m.PredmetListComponent)
  },
  {
    path: 'nastavnik',
    loadComponent: () => import('./nastavnik/nastavnik-list.component').then(m => m.NastavnikListComponent)
  },
  {
    path: 'student',
    loadComponent: () => import('./student/student-list.component').then(m => m.StudentListComponent)
  },
  {
    path: 'ispit',
    loadComponent: () => import('./ispit/ispit-list.component').then(m => m.IspitListComponent)
  }
];
