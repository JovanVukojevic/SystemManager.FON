import { Component, inject, ChangeDetectionStrategy, signal, computed } from '@angular/core';
import { MatTableModule } from '@angular/material/table';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';
import { MatCardModule } from '@angular/material/card';
import { MatDialog } from '@angular/material/dialog';
import { MatSnackBar } from '@angular/material/snack-bar';
import { SluzbaService } from '../../../core/services/sluzba.service';
import { SluzbaResponse } from '../../../core/models/projekat.models';
import { SluzbaFormComponent } from './sluzba-form.component';
import { ConfirmDialogComponent, ConfirmDialogData } from '../../../shared/components/confirm-dialog/confirm-dialog.component';
import { TextSearchComponent } from '../../../shared/components/text-search/text-search.component';

@Component({
  selector: 'app-sluzba-list',
  standalone: true,
  imports: [MatTableModule, MatButtonModule, MatIconModule, MatCardModule, TextSearchComponent],
  changeDetection: ChangeDetectionStrategy.OnPush,
  template: `
    <div class="page-header">
      <h2>Službe</h2>
      <button mat-raised-button color="primary" (click)="openAdd()">
        <mat-icon>add</mat-icon> Dodaj službu
      </button>
    </div>
    <div class="filter-bar">
      <app-text-search [value]="searchTerm()" (searchChange)="searchTerm.set($event)" />
      @if (searchTerm()) {
        <button mat-button (click)="searchTerm.set('')">Prikaži sve</button>
      }
      <span class="filter-count">Prikazano {{ filteredData().length }} od {{ allData().length }}</span>
    </div>
    <mat-card>
      <mat-card-content>
      <table mat-table [dataSource]="filteredData()" style="width: 100%;">
        <ng-container matColumnDef="sluzbaId">
          <th mat-header-cell *matHeaderCellDef>ID</th>
          <td mat-cell *matCellDef="let row">{{ row.sluzbaId }}</td>
        </ng-container>

        <ng-container matColumnDef="naziv">
          <th mat-header-cell *matHeaderCellDef>Naziv</th>
          <td mat-cell *matCellDef="let row">{{ row.naziv }}</td>
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
            <p>Još uvek nema unetih službi</p>
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
export class SluzbaListComponent {
  private service = inject(SluzbaService);
  private dialog = inject(MatDialog);
  private snackBar = inject(MatSnackBar);

  columns = ['sluzbaId', 'naziv', 'akcije'];
  allData = signal<SluzbaResponse[]>([]);
  searchTerm = signal('');
  filteredData = computed(() => {
    const term = this.searchTerm().toLowerCase();
    return this.allData().filter(s => !term || s.naziv.toLowerCase().includes(term));
  });

  constructor() {
    this.load();
  }

  load() {
    this.service.getAll().subscribe({
      next: (data) => this.allData.set(data),
      error: (err: any) => this.showError(err)
    });
  }

  openAdd() {
    this.dialog.open(SluzbaFormComponent, { data: null, width: '400px' })
      .afterClosed().subscribe(result => {
        if (result) {
          this.showSuccess('Služba dodata');
          this.load();
        }
      });
  }

  openEdit(row: SluzbaResponse) {
    this.dialog.open(SluzbaFormComponent, { data: row, width: '400px' })
      .afterClosed().subscribe(result => {
        if (result) {
          this.showSuccess('Služba izmenjena');
          this.load();
        }
      });
  }

  openDelete(row: SluzbaResponse) {
    const data: ConfirmDialogData = {
      title: 'Brisanje službe',
      message: `Da li ste sigurni da želite da obrišete službu "${row.naziv}"?`
    };
    this.dialog.open(ConfirmDialogComponent, { data, width: '400px' })
      .afterClosed().subscribe(confirmed => {
        if (confirmed) {
          this.service.delete(row.sluzbaId).subscribe({
            next: () => {
              this.showSuccess('Služba obrisana');
              this.load();
            },
            error: (err: any) => this.showError(err)
          });
        }
      });
  }

  private showSuccess(message: string) {
    this.snackBar.open(message, 'Zatvori', { duration: 3000, panelClass: ['snack-success'] });
  }

  private showError(err: any) {
    this.snackBar.open(err.error?.message ?? 'Greška', 'Zatvori', { duration: 5000, panelClass: ['snack-error'] });
  }
}
