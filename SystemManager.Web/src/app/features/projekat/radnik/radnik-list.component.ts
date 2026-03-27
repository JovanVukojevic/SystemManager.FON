import { Component, inject, ChangeDetectionStrategy, signal, computed } from '@angular/core';
import { Router } from '@angular/router';
import { forkJoin } from 'rxjs';
import { MatTableModule } from '@angular/material/table';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';
import { MatCardModule } from '@angular/material/card';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatSelectModule } from '@angular/material/select';
import { MatDialog } from '@angular/material/dialog';
import { MatSnackBar } from '@angular/material/snack-bar';
import { RadnikService } from '../../../core/services/radnik.service';
import { RadnoMestoService } from '../../../core/services/radnomesto.service';
import { SluzbaService } from '../../../core/services/sluzba.service';
import { RadnikResponse, RadnoMestoResponse, SluzbaResponse } from '../../../core/models/projekat.models';
import { RadnikFormComponent } from './radnik-form.component';
import { ConfirmDialogComponent, ConfirmDialogData } from '../../../shared/components/confirm-dialog/confirm-dialog.component';
import { TextSearchComponent } from '../../../shared/components/text-search/text-search.component';

@Component({
  selector: 'app-radnik-list',
  standalone: true,
  imports: [MatTableModule, MatButtonModule, MatIconModule, MatCardModule, MatFormFieldModule, MatSelectModule, TextSearchComponent],
  changeDetection: ChangeDetectionStrategy.OnPush,
  template: `
    <div class="page-header">
      <h2>Radnici</h2>
      <button mat-raised-button color="primary" (click)="openAdd()">
        <mat-icon>add</mat-icon> Dodaj radnika
      </button>
    </div>
    <div class="filter-bar">
      <app-text-search [value]="searchTerm()" (searchChange)="searchTerm.set($event)" />
      <mat-form-field appearance="outline" subscriptSizing="dynamic">
        <mat-label>Radno mesto</mat-label>
        <mat-select multiple [value]="selectedRadnaMesta()" (selectionChange)="selectedRadnaMesta.set($event.value)">
          @for (rm of radnoMestoOptions(); track rm.radnoMestoId) {
            <mat-option [value]="rm.radnoMestoId">{{ rm.naziv }}</mat-option>
          }
        </mat-select>
      </mat-form-field>
      <mat-form-field appearance="outline" subscriptSizing="dynamic">
        <mat-label>Služba</mat-label>
        <mat-select multiple [value]="selectedSluzbe()" (selectionChange)="selectedSluzbe.set($event.value)">
          @for (s of sluzbaOptions(); track s.sluzbaId) {
            <mat-option [value]="s.sluzbaId">{{ s.naziv }}</mat-option>
          }
        </mat-select>
      </mat-form-field>
      @if (hasActiveFilters()) {
        <button mat-button (click)="resetFilters()">Prikaži sve</button>
      }
      <span class="filter-count">Prikazano {{ filteredData().length }} od {{ allData().length }}</span>
    </div>
    <mat-card>
      <mat-card-content>
      <table mat-table [dataSource]="filteredData()" style="width: 100%;">
        <ng-container matColumnDef="radnikId">
          <th mat-header-cell *matHeaderCellDef>ID</th>
          <td mat-cell *matCellDef="let row">{{ row.radnikId }}</td>
        </ng-container>

        <ng-container matColumnDef="ime">
          <th mat-header-cell *matHeaderCellDef>Ime</th>
          <td mat-cell *matCellDef="let row">{{ row.ime }}</td>
        </ng-container>

        <ng-container matColumnDef="radnoMesto">
          <th mat-header-cell *matHeaderCellDef>Radno Mesto</th>
          <td mat-cell *matCellDef="let row">{{ row.radnoMesto?.naziv }}</td>
        </ng-container>

        <ng-container matColumnDef="sluzba">
          <th mat-header-cell *matHeaderCellDef>Služba</th>
          <td mat-cell *matCellDef="let row">{{ row.sluzba?.naziv }}</td>
        </ng-container>

        <ng-container matColumnDef="akcije">
          <th mat-header-cell *matHeaderCellDef></th>
          <td mat-cell *matCellDef="let row" style="text-align: right;">
            <span style="display: inline-flex; align-items: center; gap: 4px;">
              <button mat-stroked-button color="primary" (click)="openDetail(row)" style="font-size: 12px; line-height: 28px; padding: 0 10px; min-width: unset;">Isplate</button>
              <button mat-icon-button color="primary" (click)="openEdit(row)">
                <mat-icon>edit</mat-icon>
              </button>
              <button mat-icon-button color="warn" (click)="openDelete(row)">
                <mat-icon>delete</mat-icon>
              </button>
            </span>
          </td>
        </ng-container>

        <tr mat-header-row *matHeaderRowDef="columns"></tr>
        <tr mat-row *matRowDef="let row; columns: columns;"></tr>
      </table>
      @if (filteredData().length === 0) {
        <div class="empty-state">
          @if (allData().length === 0) {
            <mat-icon>inbox</mat-icon>
            <p>Još uvek nema unetih radnika</p>
          } @else {
            <mat-icon>search_off</mat-icon>
            <p>Nema rezultata za zadatu pretragu</p>
          }
        </div>
      }
      </mat-card-content>
    </mat-card>
  `
})
export class RadnikListComponent {
  private service = inject(RadnikService);
  private dialog = inject(MatDialog);
  private snackBar = inject(MatSnackBar);
  private router = inject(Router);

  columns = ['radnikId', 'ime', 'radnoMesto', 'sluzba', 'akcije'];
  allData = signal<RadnikResponse[]>([]);
  searchTerm = signal('');
  selectedRadnaMesta = signal<number[]>([]);
  selectedSluzbe = signal<number[]>([]);
  radnoMestoOptions = signal<RadnoMestoResponse[]>([]);
  sluzbaOptions = signal<SluzbaResponse[]>([]);
  hasActiveFilters = computed(() =>
    this.searchTerm() !== '' || this.selectedRadnaMesta().length > 0 || this.selectedSluzbe().length > 0
  );
  filteredData = computed(() => {
    const term = this.searchTerm().toLowerCase();
    const rm = this.selectedRadnaMesta();
    const sl = this.selectedSluzbe();
    return this.allData().filter(r =>
      (!term || r.ime.toLowerCase().includes(term)) &&
      (rm.length === 0 || rm.includes(r.radnoMesto?.radnoMestoId)) &&
      (sl.length === 0 || sl.includes(r.sluzba?.sluzbaId))
    );
  });

  constructor() {
    this.load();
    forkJoin({
      radnaMesta: inject(RadnoMestoService).getAll(),
      sluzbe: inject(SluzbaService).getAll()
    }).subscribe(({ radnaMesta, sluzbe }) => {
      this.radnoMestoOptions.set(radnaMesta);
      this.sluzbaOptions.set(sluzbe);
    });
  }

  resetFilters() {
    this.searchTerm.set('');
    this.selectedRadnaMesta.set([]);
    this.selectedSluzbe.set([]);
  }

  load() {
    this.service.getAll().subscribe({
      next: (data) => this.allData.set(data),
      error: (err: any) => this.showError(err)
    });
  }

  openDetail(row: RadnikResponse) {
    this.router.navigate(['/projekat/radnik', row.radnikId]);
  }

  openAdd() {
    this.dialog.open(RadnikFormComponent, { data: null, width: '700px' })
      .afterClosed().subscribe(result => {
        if (result) {
          this.showSuccess('Radnik dodat');
          this.load();
        }
      });
  }

  openEdit(row: RadnikResponse) {
    this.dialog.open(RadnikFormComponent, { data: row, width: '700px' })
      .afterClosed().subscribe(result => {
        if (result) {
          this.showSuccess('Radnik izmenjen');
          this.load();
        }
      });
  }

  openDelete(row: RadnikResponse) {
    const data: ConfirmDialogData = {
      title: 'Brisanje radnika',
      message: `Da li ste sigurni da želite da obrišete radnika "${row.ime}"?`
    };
    this.dialog.open(ConfirmDialogComponent, { data, width: '400px' })
      .afterClosed().subscribe(confirmed => {
        if (confirmed) {
          this.service.delete(row.radnikId).subscribe({
            next: () => {
              this.showSuccess('Radnik obrisan');
              this.load();
            },
            error: (err: any) => this.showError(err)
          });
        }
      });
  }

  private showSuccess(message: string) {
    this.snackBar.open(message, 'Zatvori', {
      duration: 3000,
      panelClass: ['snack-success']
    });
  }

  private showError(err: any) {
    const message = err.error?.message ?? 'Greška';
    this.snackBar.open(message, 'Zatvori', {
      duration: 5000,
      panelClass: ['snack-error']
    });
  }
}
