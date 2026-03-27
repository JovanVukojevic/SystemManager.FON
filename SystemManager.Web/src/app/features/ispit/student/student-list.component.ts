import { Component, inject, ChangeDetectionStrategy, signal, computed } from '@angular/core';
import { DatePipe } from '@angular/common';
import { MatTableModule } from '@angular/material/table';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';
import { MatCardModule } from '@angular/material/card';
import { MatDialog } from '@angular/material/dialog';
import { MatSnackBar } from '@angular/material/snack-bar';
import { StudentService } from '../../../core/services/student.service';
import { StudentResponse } from '../../../core/models/ispit.models';
import { StudentFormComponent } from './student-form.component';
import { ConfirmDialogComponent, ConfirmDialogData } from '../../../shared/components/confirm-dialog/confirm-dialog.component';
import { TextSearchComponent } from '../../../shared/components/text-search/text-search.component';

@Component({
  selector: 'app-student-list',
  standalone: true,
  imports: [MatTableModule, MatButtonModule, MatIconModule, MatCardModule, DatePipe, TextSearchComponent],
  changeDetection: ChangeDetectionStrategy.OnPush,
  template: `
    <div class="page-header">
      <h2>Studenti</h2>
      <button mat-raised-button color="primary" (click)="openAdd()">
        <mat-icon>add</mat-icon> Dodaj studenta
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
        <ng-container matColumnDef="brojIndeksa">
          <th mat-header-cell *matHeaderCellDef>Broj indeksa</th>
          <td mat-cell *matCellDef="let row">{{ row.brojIndeksa }}</td>
        </ng-container>

        <ng-container matColumnDef="ime">
          <th mat-header-cell *matHeaderCellDef>Ime</th>
          <td mat-cell *matCellDef="let row">{{ row.ime }}</td>
        </ng-container>

        <ng-container matColumnDef="datumRodjenja">
          <th mat-header-cell *matHeaderCellDef>Datum rođenja</th>
          <td mat-cell *matCellDef="let row">{{ row.datumRodjenja | date:'d.M.yyyy.' }}</td>
        </ng-container>

        <ng-container matColumnDef="semestar">
          <th mat-header-cell *matHeaderCellDef>Semestar</th>
          <td mat-cell *matCellDef="let row">{{ row.semestar }}</td>
        </ng-container>

        <ng-container matColumnDef="starost">
          <th mat-header-cell *matHeaderCellDef>Starost</th>
          <td mat-cell *matCellDef="let row">{{ row.starost }}</td>
        </ng-container>

        <ng-container matColumnDef="prosecnaOcena">
          <th mat-header-cell *matHeaderCellDef>Prosečna ocena</th>
          <td mat-cell *matCellDef="let row">{{ row.prosecnaOcena === 0 || row.prosecnaOcena == null ? '/' : row.prosecnaOcena }}</td>
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
            <p>Još uvek nema unetih studenata</p>
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
export class StudentListComponent {
  private service = inject(StudentService);
  private dialog = inject(MatDialog);
  private snackBar = inject(MatSnackBar);

  columns = ['brojIndeksa', 'ime', 'datumRodjenja', 'semestar', 'starost', 'prosecnaOcena', 'akcije'];
  allData = signal<StudentResponse[]>([]);
  searchTerm = signal('');
  filteredData = computed(() => {
    const term = this.searchTerm().toLowerCase();
    return this.allData().filter(s =>
      !term || s.brojIndeksa.toLowerCase().includes(term) || s.ime.toLowerCase().includes(term)
    );
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
    this.dialog.open(StudentFormComponent, { data: null, width: '450px' })
      .afterClosed().subscribe(result => {
        if (result) {
          this.showSuccess('Student dodat');
          this.load();
        }
      });
  }

  openEdit(row: StudentResponse) {
    this.dialog.open(StudentFormComponent, { data: row, width: '450px' })
      .afterClosed().subscribe(result => {
        if (result) {
          this.showSuccess('Student izmenjen');
          this.load();
        }
      });
  }

  openDelete(row: StudentResponse) {
    const data: ConfirmDialogData = {
      title: 'Brisanje studenta',
      message: `Da li ste sigurni da želite da obrišete studenta "${row.ime}" (${row.brojIndeksa})?`
    };
    this.dialog.open(ConfirmDialogComponent, { data, width: '400px' })
      .afterClosed().subscribe(confirmed => {
        if (confirmed) {
          this.service.delete(row.brojIndeksa).subscribe({
            next: () => {
              this.showSuccess('Student obrisan');
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
