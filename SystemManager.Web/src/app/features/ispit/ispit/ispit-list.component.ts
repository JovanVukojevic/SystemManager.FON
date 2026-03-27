import { Component, inject, ChangeDetectionStrategy, signal, computed } from '@angular/core';
import { DatePipe } from '@angular/common';
import { MatTableModule } from '@angular/material/table';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';
import { MatCardModule } from '@angular/material/card';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';
import { MatDatepickerModule } from '@angular/material/datepicker';
import { MatDialog } from '@angular/material/dialog';
import { MatSnackBar } from '@angular/material/snack-bar';
import { IspitService } from '../../../core/services/ispit.service';
import { IspitResponse } from '../../../core/models/ispit.models';
import { IspitFormComponent } from './ispit-form.component';
import { ConfirmDialogComponent, ConfirmDialogData } from '../../../shared/components/confirm-dialog/confirm-dialog.component';
import { TextSearchComponent } from '../../../shared/components/text-search/text-search.component';

@Component({
  selector: 'app-ispit-list',
  standalone: true,
  imports: [MatTableModule, MatButtonModule, MatIconModule, MatCardModule, DatePipe, MatFormFieldModule, MatInputModule, MatDatepickerModule, TextSearchComponent],
  changeDetection: ChangeDetectionStrategy.OnPush,
  template: `
    <div class="page-header">
      <h2>Ispiti</h2>
      <button mat-raised-button color="primary" (click)="openAdd()">
        <mat-icon>add</mat-icon> Dodaj ispit
      </button>
    </div>
    <div class="filter-bar">
      <app-text-search [value]="searchTerm()" (searchChange)="searchTerm.set($event)" />
      <mat-form-field appearance="outline" subscriptSizing="dynamic">
        <mat-label>Datum od</mat-label>
        <input matInput [matDatepicker]="pickerFrom" [value]="dateFrom()" (dateChange)="onDateFromChange($event)">
        <mat-datepicker-toggle matSuffix [for]="pickerFrom" />
        <mat-datepicker #pickerFrom />
      </mat-form-field>
      <mat-form-field appearance="outline" subscriptSizing="dynamic">
        <mat-label>Datum do</mat-label>
        <input matInput [matDatepicker]="pickerTo" [value]="dateTo()" (dateChange)="onDateToChange($event)">
        <mat-datepicker-toggle matSuffix [for]="pickerTo" />
        <mat-datepicker #pickerTo />
      </mat-form-field>
      @if (hasActiveFilters()) {
        <button mat-button (click)="resetFilters()">Prikaži sve</button>
      }
      <span class="filter-count">Prikazano {{ filteredData().length }} od {{ allData().length }}</span>
    </div>
    <mat-card>
      <mat-card-content>
      <table mat-table [dataSource]="filteredData()" style="width: 100%;">
        <ng-container matColumnDef="idIspit">
          <th mat-header-cell *matHeaderCellDef>ID</th>
          <td mat-cell *matCellDef="let row">{{ row.idIspit }}</td>
        </ng-container>

        <ng-container matColumnDef="student">
          <th mat-header-cell *matHeaderCellDef>Student</th>
          <td mat-cell *matCellDef="let row">{{ row.student?.ime }}</td>
        </ng-container>

        <ng-container matColumnDef="predmet">
          <th mat-header-cell *matHeaderCellDef>Predmet</th>
          <td mat-cell *matCellDef="let row">{{ row.predmet?.naziv }}</td>
        </ng-container>

        <ng-container matColumnDef="nastavnik">
          <th mat-header-cell *matHeaderCellDef>Nastavnik</th>
          <td mat-cell *matCellDef="let row">{{ row.nastavnik?.ime }}{{ row.nastavnik?.zvanje?.naziv ? ' (' + row.nastavnik.zvanje.naziv.toLowerCase() + ')' : '' }}</td>
        </ng-container>

        <ng-container matColumnDef="ocena">
          <th mat-header-cell *matHeaderCellDef>Ocena</th>
          <td mat-cell *matCellDef="let row">{{ row.ocena }}</td>
        </ng-container>

        <ng-container matColumnDef="datumPolaganja">
          <th mat-header-cell *matHeaderCellDef>Datum polaganja</th>
          <td mat-cell *matCellDef="let row">{{ row.datumPolaganja | date:'d.M.yyyy.' }}</td>
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
            <p>Još uvek nema unetih ispita</p>
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
export class IspitListComponent {
  private service = inject(IspitService);
  private dialog = inject(MatDialog);
  private snackBar = inject(MatSnackBar);

  columns = ['idIspit', 'student', 'predmet', 'nastavnik', 'ocena', 'datumPolaganja', 'akcije'];
  allData = signal<IspitResponse[]>([]);
  searchTerm = signal('');
  dateFrom = signal<Date | null>(null);
  dateTo = signal<Date | null>(null);
  hasActiveFilters = computed(() => this.searchTerm() !== '' || this.dateFrom() !== null || this.dateTo() !== null);
  filteredData = computed(() => {
    const term = this.searchTerm().toLowerCase();
    const from = this.dateFrom();
    const to = this.dateTo();
    return this.allData().filter(i => {
      const textMatch = !term ||
        i.student?.ime?.toLowerCase().includes(term) ||
        i.predmet?.naziv?.toLowerCase().includes(term) ||
        i.nastavnik?.ime?.toLowerCase().includes(term) ||
        i.nastavnik?.zvanje?.naziv?.toLowerCase().includes(term);
      const dateStr = i.datumPolaganja?.slice(0, 10) ?? '';
      const fromStr = from ? this.toDateString(from) : '';
      const toStr = to ? this.toDateString(to) : '';
      const dateMatch = (!fromStr || dateStr >= fromStr) && (!toStr || dateStr <= toStr);
      return textMatch && dateMatch;
    });
  });

  constructor() {
    this.load();
  }

  onDateFromChange(event: any) {
    this.dateFrom.set(event.value);
  }

  onDateToChange(event: any) {
    this.dateTo.set(event.value);
  }

  resetFilters() {
    this.searchTerm.set('');
    this.dateFrom.set(null);
    this.dateTo.set(null);
  }

  private toDateString(date: Date): string {
    const y = date.getFullYear();
    const m = String(date.getMonth() + 1).padStart(2, '0');
    const d = String(date.getDate()).padStart(2, '0');
    return `${y}-${m}-${d}`;
  }

  load() {
    this.service.getAll().subscribe({
      next: (data) => this.allData.set(data),
      error: (err: any) => this.showError(err)
    });
  }

  openAdd() {
    this.dialog.open(IspitFormComponent, { data: null, width: '480px' })
      .afterClosed().subscribe(result => {
        if (result) {
          this.showSuccess('Ispit dodat');
          this.load();
        }
      });
  }

  openEdit(row: IspitResponse) {
    this.dialog.open(IspitFormComponent, { data: row, width: '480px' })
      .afterClosed().subscribe(result => {
        if (result) {
          this.showSuccess('Ispit izmenjen');
          this.load();
        }
      });
  }

  openDelete(row: IspitResponse) {
    const data: ConfirmDialogData = {
      title: 'Brisanje ispita',
      message: `Da li ste sigurni da želite da obrišete ispit studenta "${row.student?.ime}" iz predmeta "${row.predmet?.naziv}"?`
    };
    this.dialog.open(ConfirmDialogComponent, { data, width: '400px' })
      .afterClosed().subscribe(confirmed => {
        if (confirmed) {
          this.service.delete(row.idIspit).subscribe({
            next: () => {
              this.showSuccess('Ispit obrisan');
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
