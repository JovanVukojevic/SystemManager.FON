import { Component, inject, ChangeDetectionStrategy, signal, computed } from '@angular/core';
import { MatTableModule } from '@angular/material/table';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';
import { MatCardModule } from '@angular/material/card';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatSelectModule } from '@angular/material/select';
import { MatDialog } from '@angular/material/dialog';
import { MatSnackBar } from '@angular/material/snack-bar';
import { ProjekatService } from '../../../core/services/projekat.service';
import { ProjekatResponse } from '../../../core/models/projekat.models';
import { ProjekatFormComponent } from './projekat-form.component';
import { ConfirmDialogComponent, ConfirmDialogData } from '../../../shared/components/confirm-dialog/confirm-dialog.component';
import { TextSearchComponent } from '../../../shared/components/text-search/text-search.component';

@Component({
  selector: 'app-projekat-list',
  standalone: true,
  imports: [MatTableModule, MatButtonModule, MatIconModule, MatCardModule, MatFormFieldModule, MatSelectModule, TextSearchComponent],
  changeDetection: ChangeDetectionStrategy.OnPush,
  template: `
    <div class="page-header">
      <h2>Projekti</h2>
      <button mat-raised-button color="primary" (click)="openAdd()">
        <mat-icon>add</mat-icon> Dodaj projekat
      </button>
    </div>
    <div class="filter-bar">
      <app-text-search [value]="searchTerm()" (searchChange)="searchTerm.set($event)" />
      <mat-form-field appearance="outline" subscriptSizing="dynamic">
        <mat-label>Klasa</mat-label>
        <mat-select multiple [value]="selectedKlase()" (selectionChange)="selectedKlase.set($event.value)">
          @for (k of klasaOptions; track k) {
            <mat-option [value]="k">Klasa {{ k }}</mat-option>
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
        <ng-container matColumnDef="projekatId">
          <th mat-header-cell *matHeaderCellDef>ID</th>
          <td mat-cell *matCellDef="let row">{{ row.projekatId }}</td>
        </ng-container>

        <ng-container matColumnDef="naziv">
          <th mat-header-cell *matHeaderCellDef>Naziv</th>
          <td mat-cell *matCellDef="let row">{{ row.naziv }}</td>
        </ng-container>

        <ng-container matColumnDef="budzet">
          <th mat-header-cell *matHeaderCellDef>Budzet</th>
          <td mat-cell *matCellDef="let row">{{ row.budzet }}</td>
        </ng-container>

        <ng-container matColumnDef="klasa">
          <th mat-header-cell *matHeaderCellDef>Klasa</th>
          <td mat-cell *matCellDef="let row">{{ row.klasa }}</td>
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
            <p>Još uvek nema unetih projekata</p>
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
export class ProjekatListComponent {
  private service = inject(ProjekatService);
  private dialog = inject(MatDialog);
  private snackBar = inject(MatSnackBar);

  columns = ['projekatId', 'naziv', 'budzet', 'klasa', 'akcije'];
  allData = signal<ProjekatResponse[]>([]);
  searchTerm = signal('');
  selectedKlase = signal<number[]>([]);
  klasaOptions = [1, 2, 3];
  hasActiveFilters = computed(() => this.searchTerm() !== '' || this.selectedKlase().length > 0);
  filteredData = computed(() => {
    const term = this.searchTerm().toLowerCase();
    const klase = this.selectedKlase();
    return this.allData().filter(p =>
      (!term || p.naziv.toLowerCase().includes(term)) &&
      (klase.length === 0 || klase.includes(p.klasa))
    );
  });

  constructor() {
    this.load();
  }

  resetFilters() {
    this.searchTerm.set('');
    this.selectedKlase.set([]);
  }

  load() {
    this.service.getAll().subscribe({
      next: (data) => this.allData.set(data),
      error: (err: any) => this.showError(err)
    });
  }

  openAdd() {
    this.dialog.open(ProjekatFormComponent, { data: null, width: '800px' })
      .afterClosed().subscribe(result => {
        if (result) {
          this.showSuccess('Projekat dodat');
          this.load();
        }
      });
  }

  openEdit(row: ProjekatResponse) {
    this.dialog.open(ProjekatFormComponent, { data: row, width: '800px' })
      .afterClosed().subscribe(result => {
        if (result) {
          this.showSuccess('Projekat izmenjen');
          this.load();
        }
      });
  }

  openDelete(row: ProjekatResponse) {
    const data: ConfirmDialogData = {
      title: 'Brisanje projekta',
      message: `Da li ste sigurni da želite da obrišete projekat "${row.naziv}"?`
    };
    this.dialog.open(ConfirmDialogComponent, { data, width: '400px' })
      .afterClosed().subscribe(confirmed => {
        if (confirmed) {
          this.service.delete(row.projekatId).subscribe({
            next: () => {
              this.showSuccess('Projekat obrisan');
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
