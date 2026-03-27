import { Component, inject, ChangeDetectionStrategy, signal, computed } from '@angular/core';
import { MatTableModule } from '@angular/material/table';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';
import { MatCardModule } from '@angular/material/card';
import { MatDialog } from '@angular/material/dialog';
import { MatSnackBar } from '@angular/material/snack-bar';
import { ZvanjeService } from '../../../core/services/zvanje.service';
import { ZvanjeResponse } from '../../../core/models/ispit.models';
import { ZvanjeFormComponent } from './zvanje-form.component';
import { ConfirmDialogComponent, ConfirmDialogData } from '../../../shared/components/confirm-dialog/confirm-dialog.component';
import { TextSearchComponent } from '../../../shared/components/text-search/text-search.component';

@Component({
  selector: 'app-zvanje-list',
  standalone: true,
  imports: [MatTableModule, MatButtonModule, MatIconModule, MatCardModule, TextSearchComponent],
  changeDetection: ChangeDetectionStrategy.OnPush,
  template: `
    <div class="page-header">
      <h2>Zvanja</h2>
      <button mat-raised-button color="primary" (click)="openAdd()">
        <mat-icon>add</mat-icon> Dodaj zvanje
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
        <ng-container matColumnDef="idZvanje">
          <th mat-header-cell *matHeaderCellDef>ID</th>
          <td mat-cell *matCellDef="let row">{{ row.idZvanje }}</td>
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
            <p>Još uvek nema unetih zvanja</p>
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
export class ZvanjeListComponent {
  private service = inject(ZvanjeService);
  private dialog = inject(MatDialog);
  private snackBar = inject(MatSnackBar);

  columns = ['idZvanje', 'naziv', 'akcije'];
  allData = signal<ZvanjeResponse[]>([]);
  searchTerm = signal('');
  filteredData = computed(() => {
    const term = this.searchTerm().toLowerCase();
    return this.allData().filter(z => !term || z.naziv.toLowerCase().includes(term));
  });

  constructor() {
    this.load();
  }

  load() {
    this.service.getAll().subscribe({
      next: (data) => this.allData.set(data),
      error: (err) => this.showError(err)
    });
  }

  openAdd() {
    this.dialog.open(ZvanjeFormComponent, { data: null, width: '400px' })
      .afterClosed().subscribe(result => {
        if (result) {
          this.showSuccess('Zvanje dodato');
          this.load();
        }
      });
  }

  openEdit(row: ZvanjeResponse) {
    this.dialog.open(ZvanjeFormComponent, { data: row, width: '400px' })
      .afterClosed().subscribe(result => {
        if (result) {
          this.showSuccess('Zvanje izmenjeno');
          this.load();
        }
      });
  }

  openDelete(row: ZvanjeResponse) {
    const data: ConfirmDialogData = {
      title: 'Brisanje zvanja',
      message: `Da li ste sigurni da želite da obrišete zvanje "${row.naziv}"?`
    };
    this.dialog.open(ConfirmDialogComponent, { data, width: '400px' })
      .afterClosed().subscribe(confirmed => {
        if (confirmed) {
          this.service.delete(row.idZvanje).subscribe({
            next: () => {
              this.showSuccess('Zvanje obrisano');
              this.load();
            },
            error: (err) => this.showError(err)
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
