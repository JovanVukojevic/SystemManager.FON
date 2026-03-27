import { Component, inject, ChangeDetectionStrategy, signal, computed } from '@angular/core';
import { MatTableModule } from '@angular/material/table';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';
import { MatCardModule } from '@angular/material/card';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatSelectModule } from '@angular/material/select';
import { MatDialog } from '@angular/material/dialog';
import { MatSnackBar } from '@angular/material/snack-bar';
import { NastavnikService } from '../../../core/services/nastavnik.service';
import { ZvanjeService } from '../../../core/services/zvanje.service';
import { NastavnikResponse, ZvanjeResponse } from '../../../core/models/ispit.models';
import { NastavnikFormComponent } from './nastavnik-form.component';
import { ConfirmDialogComponent, ConfirmDialogData } from '../../../shared/components/confirm-dialog/confirm-dialog.component';
import { TextSearchComponent } from '../../../shared/components/text-search/text-search.component';

@Component({
  selector: 'app-nastavnik-list',
  standalone: true,
  imports: [MatTableModule, MatButtonModule, MatIconModule, MatCardModule, MatFormFieldModule, MatSelectModule, TextSearchComponent],
  changeDetection: ChangeDetectionStrategy.OnPush,
  template: `
    <div class="page-header">
      <h2>Nastavnici</h2>
      <button mat-raised-button color="primary" (click)="openAdd()">
        <mat-icon>add</mat-icon> Dodaj nastavnika
      </button>
    </div>
    <div class="filter-bar">
      <app-text-search [value]="searchTerm()" (searchChange)="searchTerm.set($event)" />
      <mat-form-field appearance="outline" subscriptSizing="dynamic">
        <mat-label>Zvanje</mat-label>
        <mat-select multiple [value]="selectedZvanja()" (selectionChange)="selectedZvanja.set($event.value)">
          @for (z of zvanjeOptions(); track z.idZvanje) {
            <mat-option [value]="z.idZvanje">{{ z.naziv }}</mat-option>
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
        <ng-container matColumnDef="idNastavnik">
          <th mat-header-cell *matHeaderCellDef>ID</th>
          <td mat-cell *matCellDef="let row">{{ row.idNastavnik }}</td>
        </ng-container>

        <ng-container matColumnDef="ime">
          <th mat-header-cell *matHeaderCellDef>Ime</th>
          <td mat-cell *matCellDef="let row">{{ row.ime }}</td>
        </ng-container>

        <ng-container matColumnDef="zvanje">
          <th mat-header-cell *matHeaderCellDef>Zvanje</th>
          <td mat-cell *matCellDef="let row">{{ row.zvanje?.naziv }}</td>
        </ng-container>

        <ng-container matColumnDef="akcije">
          <th mat-header-cell *matHeaderCellDef></th>
          <td mat-cell *matCellDef="let row">
            <button mat-icon-button color="primary" (click)="openEdit(row)">
              <mat-icon>edit</mat-icon>
            </button>
            <button mat-icon-button color="warn" (click)="openDelete(row)">
              <mat-icon>delete</mat-icon>
            </button>
          </td>
        </ng-container>

        <tr mat-header-row *matHeaderRowDef="columns"></tr>
        <tr mat-row *matRowDef="let row; columns: columns;"></tr>
      </table>
      @if (filteredData().length === 0) {
        <div class="empty-state">
          @if (allData().length === 0) {
            <mat-icon>inbox</mat-icon>
            <p>Još uvek nema unetih nastavnika</p>
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
export class NastavnikListComponent {
  private service = inject(NastavnikService);
  private dialog = inject(MatDialog);
  private snackBar = inject(MatSnackBar);

  columns = ['idNastavnik', 'ime', 'zvanje', 'akcije'];
  allData = signal<NastavnikResponse[]>([]);
  searchTerm = signal('');
  selectedZvanja = signal<number[]>([]);
  zvanjeOptions = signal<ZvanjeResponse[]>([]);
  hasActiveFilters = computed(() => this.searchTerm() !== '' || this.selectedZvanja().length > 0);
  filteredData = computed(() => {
    const term = this.searchTerm().toLowerCase();
    const zvIds = this.selectedZvanja();
    return this.allData().filter(n =>
      (!term || n.ime.toLowerCase().includes(term)) &&
      (zvIds.length === 0 || zvIds.includes(n.zvanje?.idZvanje))
    );
  });

  constructor() {
    this.load();
    inject(ZvanjeService).getAll().subscribe(data => this.zvanjeOptions.set(data));
  }

  resetFilters() {
    this.searchTerm.set('');
    this.selectedZvanja.set([]);
  }

  load() {
    this.service.getAll().subscribe({
      next: (data) => this.allData.set(data),
      error: (err: any) => this.showError(err)
    });
  }

  openAdd() {
    this.dialog.open(NastavnikFormComponent, { data: null, width: '400px' })
      .afterClosed().subscribe(result => {
        if (result) {
          this.showSuccess('Nastavnik dodat');
          this.load();
        }
      });
  }

  openEdit(row: NastavnikResponse) {
    this.dialog.open(NastavnikFormComponent, { data: row, width: '400px' })
      .afterClosed().subscribe(result => {
        if (result) {
          this.showSuccess('Nastavnik izmenjen');
          this.load();
        }
      });
  }

  openDelete(row: NastavnikResponse) {
    const data: ConfirmDialogData = {
      title: 'Brisanje nastavnika',
      message: `Da li ste sigurni da želite da obrišete nastavnika "${row.ime}"?`
    };
    this.dialog.open(ConfirmDialogComponent, { data, width: '400px' })
      .afterClosed().subscribe(confirmed => {
        if (confirmed) {
          this.service.delete(row.idNastavnik).subscribe({
            next: () => {
              this.showSuccess('Nastavnik obrisan');
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
