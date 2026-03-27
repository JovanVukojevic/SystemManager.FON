import { Component, inject, ChangeDetectionStrategy, signal, computed, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { DatePipe } from '@angular/common';
import { MatTableModule } from '@angular/material/table';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';
import { MatCardModule } from '@angular/material/card';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';
import { MatSelectModule } from '@angular/material/select';
import { MatDatepickerModule } from '@angular/material/datepicker';
import { MatDialog } from '@angular/material/dialog';
import { MatSnackBar } from '@angular/material/snack-bar';
import { RadnikService } from '../../../core/services/radnik.service';
import { IsplataService } from '../../../core/services/isplata.service';
import { RadnikResponse, IsplataResponse } from '../../../core/models/projekat.models';
import { IsplataFormComponent, IsplataFormData } from './isplata-form.component';
import { ConfirmDialogComponent, ConfirmDialogData } from '../../../shared/components/confirm-dialog/confirm-dialog.component';

@Component({
  selector: 'app-radnik-detail',
  standalone: true,
  imports: [MatTableModule, MatButtonModule, MatIconModule, MatCardModule, MatFormFieldModule, MatInputModule, MatSelectModule, MatDatepickerModule, DatePipe],
  changeDetection: ChangeDetectionStrategy.OnPush,
  template: `
    @if (radnik()) {
      <div class="page-header">
        <h2>Radnik: {{ radnik()!.ime }}</h2>
        <button mat-stroked-button (click)="goBack()">
          <mat-icon>arrow_back</mat-icon> Nazad
        </button>
      </div>

      <mat-card style="margin-bottom: 24px;">
        <mat-card-content>
          <p><strong>ID:</strong> {{ radnik()!.radnikId }}</p>
          <p><strong>Radno mesto:</strong> {{ radnik()!.radnoMesto.naziv }}</p>
          <p><strong>Služba:</strong> {{ radnik()!.sluzba.naziv }}</p>

          @if (radnik()!.projekti.length > 0) {
            <p style="margin-top: 8px;"><strong>Projekti:</strong></p>
            <ul style="padding-left: 20px;">
              @for (p of radnik()!.projekti; track p.projekatId) {
                <li>Projekat ID: {{ p.projekatId }} | Od: {{ p.datumOd | date:'d.M.yyyy.' }}
                  @if (p.datumDo) { | Do: {{ p.datumDo | date:'d.M.yyyy.' }} }
                </li>
              }
            </ul>
          }
        </mat-card-content>
      </mat-card>

      <div class="page-header">
        <h3>Isplate</h3>
        <button mat-raised-button color="primary" (click)="openAddIsplata()">
          <mat-icon>add</mat-icon> Dodaj isplatu
        </button>
      </div>
      <div class="filter-bar">
        <mat-form-field appearance="outline" subscriptSizing="dynamic">
          <mat-label>Vrsta</mat-label>
          <mat-select multiple [value]="selectedVrste()" (selectionChange)="selectedVrste.set($event.value)">
            @for (v of vrstaOptions; track v) {
              <mat-option [value]="v">{{ v }}</mat-option>
            }
          </mat-select>
        </mat-form-field>
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
        <span class="filter-count">Prikazano {{ filteredIsplate().length }} od {{ allIsplate().length }}</span>
      </div>
      <mat-card>
        <mat-card-content>
        <table mat-table [dataSource]="filteredIsplate()" style="width: 100%;">
          <ng-container matColumnDef="isplataId">
            <th mat-header-cell *matHeaderCellDef>ID</th>
            <td mat-cell *matCellDef="let row">{{ row.isplataId }}</td>
          </ng-container>

          <ng-container matColumnDef="vrsta">
            <th mat-header-cell *matHeaderCellDef>Vrsta</th>
            <td mat-cell *matCellDef="let row">{{ row.vrsta }}</td>
          </ng-container>

          <ng-container matColumnDef="datum">
            <th mat-header-cell *matHeaderCellDef>Datum</th>
            <td mat-cell *matCellDef="let row">{{ row.datum | date:'d.M.yyyy.' }}</td>
          </ng-container>

          <ng-container matColumnDef="iznos">
            <th mat-header-cell *matHeaderCellDef>Iznos</th>
            <td mat-cell *matCellDef="let row">{{ row.iznos }}</td>
          </ng-container>

          <ng-container matColumnDef="akcije">
            <th mat-header-cell *matHeaderCellDef></th>
            <td mat-cell *matCellDef="let row">
              <button mat-icon-button color="primary" (click)="openEditIsplata(row)">
                <mat-icon>edit</mat-icon>
              </button>
              <button mat-icon-button color="warn" (click)="openDeleteIsplata(row)">
                <mat-icon>delete</mat-icon>
              </button>
            </td>
          </ng-container>

          <tr mat-header-row *matHeaderRowDef="isplataColumns"></tr>
          <tr mat-row *matRowDef="let row; columns: isplataColumns;"></tr>
        </table>
        </mat-card-content>
      </mat-card>
    }
  `
})
export class RadnikDetailComponent implements OnInit {
  private route = inject(ActivatedRoute);
  private router = inject(Router);
  private radnikService = inject(RadnikService);
  private isplataService = inject(IsplataService);
  private dialog = inject(MatDialog);
  private snackBar = inject(MatSnackBar);

  radnik = signal<RadnikResponse | null>(null);
  allIsplate = signal<IsplataResponse[]>([]);
  isplataColumns = ['isplataId', 'vrsta', 'datum', 'iznos', 'akcije'];

  vrstaOptions = ['PLATA', 'BONUS', 'REGRES'];
  selectedVrste = signal<string[]>([]);
  dateFrom = signal<Date | null>(null);
  dateTo = signal<Date | null>(null);

  hasActiveFilters = computed(() =>
    this.selectedVrste().length > 0 || this.dateFrom() !== null || this.dateTo() !== null
  );

  filteredIsplate = computed(() => {
    const vrste = this.selectedVrste();
    const from = this.dateFrom();
    const to = this.dateTo();
    return this.allIsplate().filter(i => {
      const vrstaMatch = vrste.length === 0 || vrste.includes(i.vrsta);
      const dateStr = i.datum?.slice(0, 10) ?? '';
      const fromStr = from ? this.toDateString(from) : '';
      const toStr = to ? this.toDateString(to) : '';
      const dateMatch = (!fromStr || dateStr >= fromStr) && (!toStr || dateStr <= toStr);
      return vrstaMatch && dateMatch;
    });
  });

  private radnikId!: number;

  ngOnInit() {
    this.radnikId = Number(this.route.snapshot.paramMap.get('id'));
    this.loadRadnik();
    this.loadIsplate();
  }

  loadRadnik() {
    this.radnikService.getById(this.radnikId).subscribe({
      next: (data) => this.radnik.set(data),
      error: (err: any) => this.showError(err)
    });
  }

  loadIsplate() {
    this.isplataService.getAllByRadnik(this.radnikId).subscribe({
      next: (data) => this.allIsplate.set(data),
      error: (err: any) => this.showError(err)
    });
  }

  onDateFromChange(event: any) {
    this.dateFrom.set(event.value);
  }

  onDateToChange(event: any) {
    this.dateTo.set(event.value);
  }

  resetFilters() {
    this.selectedVrste.set([]);
    this.dateFrom.set(null);
    this.dateTo.set(null);
  }

  private toDateString(date: Date): string {
    const y = date.getFullYear();
    const m = String(date.getMonth() + 1).padStart(2, '0');
    const d = String(date.getDate()).padStart(2, '0');
    return `${y}-${m}-${d}`;
  }

  goBack() {
    this.router.navigate(['/projekat/radnik']);
  }

  openAddIsplata() {
    const data: IsplataFormData = { radnikId: this.radnikId, isplata: null };
    this.dialog.open(IsplataFormComponent, { data, width: '500px' })
      .afterClosed().subscribe(result => {
        if (result) {
          this.showSuccess('Isplata dodata');
          this.loadIsplate();
        }
      });
  }

  openEditIsplata(row: IsplataResponse) {
    const data: IsplataFormData = { radnikId: this.radnikId, isplata: row };
    this.dialog.open(IsplataFormComponent, { data, width: '500px' })
      .afterClosed().subscribe(result => {
        if (result) {
          this.showSuccess('Isplata izmenjena');
          this.loadIsplate();
        }
      });
  }

  openDeleteIsplata(row: IsplataResponse) {
    const data: ConfirmDialogData = {
      title: 'Brisanje isplate',
      message: `Da li ste sigurni da želite da obrišete isplatu "${row.vrsta}" od ${row.iznos}?`
    };
    this.dialog.open(ConfirmDialogComponent, { data, width: '400px' })
      .afterClosed().subscribe(confirmed => {
        if (confirmed) {
          this.isplataService.delete(this.radnikId, row.isplataId).subscribe({
            next: () => {
              this.showSuccess('Isplata obrisana');
              this.loadIsplate();
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
