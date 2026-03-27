import { Component, inject, ChangeDetectionStrategy, signal, OnInit } from '@angular/core';
import { MAT_DIALOG_DATA, MatDialogModule, MatDialogRef } from '@angular/material/dialog';
import { ReactiveFormsModule, FormBuilder, Validators } from '@angular/forms';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';
import { MatSelectModule } from '@angular/material/select';
import { MatDatepickerModule } from '@angular/material/datepicker';
import { MatButtonModule } from '@angular/material/button';
import { forkJoin, Observable } from 'rxjs';
import { IspitService } from '../../../core/services/ispit.service';
import { StudentService } from '../../../core/services/student.service';
import { PredmetService } from '../../../core/services/predmet.service';
import { NastavnikService } from '../../../core/services/nastavnik.service';
import { IspitResponse, StudentResponse, PredmetResponse, NastavnikResponse } from '../../../core/models/ispit.models';
import { SearchableDropdownComponent } from '../../../shared/components/searchable-dropdown/searchable-dropdown.component';

const OCENE = [6, 7, 8, 9, 10];

@Component({
  selector: 'app-ispit-form',
  standalone: true,
  imports: [
    MatDialogModule, ReactiveFormsModule, MatFormFieldModule,
    MatInputModule, MatSelectModule, MatDatepickerModule, MatButtonModule,
    SearchableDropdownComponent
  ],
  changeDetection: ChangeDetectionStrategy.OnPush,
  template: `
    <h2 mat-dialog-title>{{ data ? 'Izmeni ispit' : 'Dodaj ispit' }}</h2>
    <mat-dialog-content>
      @if (loading()) {
        <p style="padding: 16px 0;">Učitavanje podataka...</p>
      } @else {
        <form [formGroup]="form" style="display: flex; flex-direction: column; gap: 8px; padding-top: 8px;" (keydown.enter)="onEnter($event)">
          <app-searchable-dropdown
            formControlName="brojIndeksa"
            label="Student"
            [options]="studenti()"
            [displayFn]="studentDisplayFn"
            [valueFn]="studentValueFn"
            [filterFn]="studentFilterFn"
          />

          <app-searchable-dropdown
            formControlName="idPredmet"
            label="Predmet"
            [options]="predmeti()"
            [displayFn]="predmetDisplayFn"
            [valueFn]="predmetValueFn"
          />

          <app-searchable-dropdown
            formControlName="idNastavnik"
            label="Nastavnik"
            [options]="nastavnici()"
            [displayFn]="nastavnikDisplayFn"
            [valueFn]="nastavnikValueFn"
            [filterFn]="nastavnikFilterFn"
          />

          <mat-form-field appearance="outline">
            <mat-label>Ocena</mat-label>
            <mat-select formControlName="ocena">
              @for (o of ocene; track o) {
                <mat-option [value]="o">{{ o }}</mat-option>
              }
            </mat-select>
            @if (form.controls.ocena.hasError('required')) {
              <mat-error>Ocena je obavezna</mat-error>
            }
          </mat-form-field>

          <mat-form-field appearance="outline">
            <mat-label>Datum polaganja</mat-label>
            <input matInput [matDatepicker]="picker" formControlName="datumPolaganja" [max]="today" />
            <mat-datepicker-toggle matIconSuffix [for]="picker" />
            <mat-datepicker #picker />
            @if (form.controls.datumPolaganja.hasError('required')) {
              <mat-error>Datum polaganja je obavezan</mat-error>
            }
          </mat-form-field>

          @if (errorMessage()) {
            <p style="color: red; margin: 0;">{{ errorMessage() }}</p>
          }
        </form>
      }
    </mat-dialog-content>
    <mat-dialog-actions align="end">
      <button mat-button mat-dialog-close>Otkaži</button>
      <button mat-raised-button color="primary" (click)="submit()" [disabled]="form.invalid || loading()">Sačuvaj</button>
    </mat-dialog-actions>
  `
})
export class IspitFormComponent implements OnInit {
  data = inject<IspitResponse | null>(MAT_DIALOG_DATA);
  private dialogRef = inject(MatDialogRef<IspitFormComponent>);
  private service = inject(IspitService);
  private studentService = inject(StudentService);
  private predmetService = inject(PredmetService);
  private nastavnikService = inject(NastavnikService);
  private fb = inject(FormBuilder);

  errorMessage = signal<string | null>(null);
  loading = signal(true);
  studenti = signal<StudentResponse[]>([]);
  predmeti = signal<PredmetResponse[]>([]);
  nastavnici = signal<NastavnikResponse[]>([]);
  ocene = OCENE;
  today = new Date();

  studentDisplayFn = (s: StudentResponse) => `${s.brojIndeksa} — ${s.ime}`;
  studentValueFn = (s: StudentResponse) => s.brojIndeksa;
  studentFilterFn = (s: StudentResponse, q: string) => {
    const lower = q.toLowerCase();
    return s.brojIndeksa.toLowerCase().includes(lower) || s.ime.toLowerCase().includes(lower);
  };
  predmetDisplayFn = (p: PredmetResponse) => p.naziv;
  predmetValueFn = (p: PredmetResponse) => p.idPredmet;
  nastavnikDisplayFn = (n: NastavnikResponse) => `${n.ime} (${n.zvanje?.naziv?.toLowerCase() ?? ''})`;
  nastavnikValueFn = (n: NastavnikResponse) => n.idNastavnik;
  nastavnikFilterFn = (n: NastavnikResponse, q: string) => {
    const lower = q.toLowerCase();
    return n.ime.toLowerCase().includes(lower) || (n.zvanje?.naziv?.toLowerCase() ?? '').includes(lower);
  };

  form = this.fb.group({
    brojIndeksa: [this.data?.student?.brojIndeksa ?? null, Validators.required],
    idPredmet: [this.data?.predmet?.idPredmet ?? null, Validators.required],
    idNastavnik: [this.data?.nastavnik?.idNastavnik ?? null, Validators.required],
    ocena: [this.data?.ocena ?? null, Validators.required],
    datumPolaganja: [this.data?.datumPolaganja ? new Date(this.data.datumPolaganja) : new Date(), Validators.required]
  });

  ngOnInit() {
    forkJoin({
      studenti: this.studentService.getAll(),
      predmeti: this.predmetService.getAll(),
      nastavnici: this.nastavnikService.getAll()
    }).subscribe({
      next: ({ studenti, predmeti, nastavnici }) => {
        this.studenti.set(studenti);
        this.predmeti.set(predmeti);
        this.nastavnici.set(nastavnici);
        this.loading.set(false);
      },
      error: () => this.loading.set(false)
    });
  }

  onEnter(event: Event) {
    const target = event.target as HTMLElement;
    if (target.tagName === 'TEXTAREA' || target.tagName === 'MAT-SELECT') return;
    this.submit();
  }

  submit() {
    if (this.form.invalid) return;

    const datumValue = this.form.value.datumPolaganja as Date | null;
    const datumStr = datumValue ? datumValue.toISOString().split('T')[0] : '';

    const request = {
      brojIndeksa: this.form.value.brojIndeksa!,
      idPredmet: this.form.value.idPredmet!,
      idNastavnik: this.form.value.idNastavnik!,
      ocena: this.form.value.ocena!,
      datumPolaganja: datumStr
    };

    const call: Observable<unknown> = this.data
      ? this.service.update(this.data.idIspit, request)
      : this.service.create(request);

    call.subscribe({
      next: () => this.dialogRef.close(true),
      error: (err: any) => {
        this.errorMessage.set(err.error?.message ?? 'Greška pri čuvanju');
      }
    });
  }
}
