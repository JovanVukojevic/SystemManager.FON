import { Component, inject, ChangeDetectionStrategy, signal, computed } from '@angular/core';
import { MatTableModule } from '@angular/material/table';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';
import { MatCardModule } from '@angular/material/card';
import { MatDialog } from '@angular/material/dialog';
import { MatSnackBar } from '@angular/material/snack-bar';
import { PredmetService } from '../../../core/services/predmet.service';
import { PredmetResponse } from '../../../core/models/ispit.models';
import { PredmetFormComponent } from './predmet-form.component';
import { ConfirmDialogComponent, ConfirmDialogData } from '../../../shared/components/confirm-dialog/confirm-dialog.component';
import { TextSearchComponent } from '../../../shared/components/text-search/text-search.component';

@Component({
  selector: 'app-predmet-list',
  standalone: true,
  imports: [MatTableModule, MatButtonModule, MatIconModule, MatCardModule, TextSearchComponent],
  changeDetection: ChangeDetectionStrategy.OnPush,
  template: `
    <div class="page-header">
      <h2>Predmeti</h2>
      <button mat-raised-button color="primary" (click)="openAdd()">
        <mat-icon>add</mat-icon> Dodaj predmet
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
        <ng-container matColumnDef="idPredmet">
          <th mat-header-cell *matHeaderCellDef>ID</th>
          <td mat-cell *matCellDef="let row">{{ row.idPredmet }}</td>
        </ng-container>

        <ng-container matColumnDef="naziv">
          <th mat-header-cell *matHeaderCellDef>Naziv</th>
          <td mat-cell *matCellDef="let row">{{ row.naziv }}</td>
        </ng-container>

        <ng-container matColumnDef="espb">
          <th mat-header-cell *matHeaderCellDef>ESPB</th>
          <td mat-cell *matCellDef="let row">{{ row.espb }}</td>
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
            <p>Još uvek nema unetih predmeta</p>
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
export class PredmetListComponent {
  private service = inject(PredmetService);
  private dialog = inject(MatDialog);
  private snackBar = inject(MatSnackBar);

  columns = ['idPredmet', 'naziv', 'espb', 'akcije'];
  allData = signal<PredmetResponse[]>([]);
  searchTerm = signal('');
  filteredData = computed(() => {
    const term = this.searchTerm().toLowerCase();
    return this.allData().filter(p => !term || p.naziv.toLowerCase().includes(term));
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
    this.dialog.open(PredmetFormComponent, { data: null, width: '400px' })
      .afterClosed().subscribe(result => {
        if (result) {
          this.showSuccess('Predmet dodat');
          this.load();
        }
      });
  }

  openEdit(row: PredmetResponse) {
    this.dialog.open(PredmetFormComponent, { data: row, width: '400px' })
      .afterClosed().subscribe(result => {
        if (result) {
          this.showSuccess('Predmet izmenjen');
          this.load();
        }
      });
  }

  openDelete(row: PredmetResponse) {
    const data: ConfirmDialogData = {
      title: 'Brisanje predmeta',
      message: `Da li ste sigurni da želite da obrišete predmet "${row.naziv}"?`
    };
    this.dialog.open(ConfirmDialogComponent, { data, width: '400px' })
      .afterClosed().subscribe(confirmed => {
        if (confirmed) {
          this.service.delete(row.idPredmet).subscribe({
            next: () => {
              this.showSuccess('Predmet obrisan');
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
