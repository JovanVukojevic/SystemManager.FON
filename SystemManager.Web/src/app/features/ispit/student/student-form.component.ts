import { Component, inject, ChangeDetectionStrategy, signal, AfterViewInit, ChangeDetectorRef } from '@angular/core';
import { MAT_DIALOG_DATA, MatDialogModule, MatDialogRef } from '@angular/material/dialog';
import { ReactiveFormsModule, FormBuilder, Validators } from '@angular/forms';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';
import { MatSelectModule } from '@angular/material/select';
import { MatDatepickerModule } from '@angular/material/datepicker';
import { MatButtonModule } from '@angular/material/button';
import { Observable } from 'rxjs';
import { StudentService } from '../../../core/services/student.service';
import { StudentResponse } from '../../../core/models/ispit.models';

const SEMESTRI = ['I', 'II', 'III', 'IV', 'V', 'VI', 'VII', 'VIII'];

@Component({
  selector: 'app-student-form',
  standalone: true,
  imports: [
    MatDialogModule, ReactiveFormsModule, MatFormFieldModule,
    MatInputModule, MatSelectModule, MatDatepickerModule, MatButtonModule
  ],
  changeDetection: ChangeDetectionStrategy.OnPush,
  template: `
    <h2 mat-dialog-title>{{ data ? 'Izmeni studenta' : 'Dodaj studenta' }}</h2>
    <mat-dialog-content>
      <form [formGroup]="form" style="display: flex; flex-direction: column; gap: 8px; padding-top: 8px;" (keydown.enter)="onEnter($event)">
        <mat-form-field appearance="outline">
          <mat-label>Broj indeksa</mat-label>
          <input matInput formControlName="brojIndeksa" placeholder="YY/XXXX" />
          @if (form.controls.brojIndeksa.hasError('required')) {
            <mat-error>Broj indeksa je obavezan</mat-error>
          } @else if (form.controls.brojIndeksa.hasError('pattern')) {
            <mat-error>Format mora biti YY/XXXX, npr. 15/0189</mat-error>
          }
        </mat-form-field>

        <mat-form-field appearance="outline">
          <mat-label>Ime</mat-label>
          <input matInput formControlName="ime" />
          @if (form.controls.ime.hasError('required')) {
            <mat-error>Ime je obavezno</mat-error>
          } @else if (form.controls.ime.hasError('minlength')) {
            <mat-error>Ime mora imati najmanje 2 karaktera</mat-error>
          }
        </mat-form-field>

        <mat-form-field appearance="outline">
          <mat-label>Datum rođenja</mat-label>
          <input matInput [matDatepicker]="picker" formControlName="datumRodjenja" [max]="today" />
          <mat-datepicker-toggle matIconSuffix [for]="picker" />
          <mat-datepicker #picker />
          @if (form.controls.datumRodjenja.hasError('required')) {
            <mat-error>Datum rođenja je obavezan</mat-error>
          }
        </mat-form-field>

        <mat-form-field appearance="outline">
          <mat-label>Semestar</mat-label>
          <mat-select formControlName="semestar">
            @for (s of semestri; track s) {
              <mat-option [value]="s">{{ s }}</mat-option>
            }
          </mat-select>
          @if (form.controls.semestar.hasError('required')) {
            <mat-error>Semestar je obavezan</mat-error>
          }
        </mat-form-field>

        @if (errorMessage()) {
          <p style="color: red; margin: 0;">{{ errorMessage() }}</p>
        }
      </form>
    </mat-dialog-content>
    <mat-dialog-actions align="end">
      <button mat-button mat-dialog-close>Otkaži</button>
      <button mat-raised-button color="primary" (click)="submit()" [disabled]="form.invalid">Sačuvaj</button>
    </mat-dialog-actions>
  `
})
export class StudentFormComponent implements AfterViewInit {
  data = inject<StudentResponse | null>(MAT_DIALOG_DATA);
  private dialogRef = inject(MatDialogRef<StudentFormComponent>);
  private service = inject(StudentService);
  private fb = inject(FormBuilder);

  errorMessage = signal<string | null>(null);
  semestri = SEMESTRI;
  today = new Date();
  private cdr = inject(ChangeDetectorRef);

  form = this.fb.group({
    brojIndeksa: [{ value: this.data?.brojIndeksa ?? '', disabled: !!this.data }, [Validators.required, Validators.pattern(/^\d{2}\/\d{4}$/)]],
    ime: [this.data?.ime ?? '', [Validators.required, Validators.minLength(2)]],
    datumRodjenja: [this.data?.datumRodjenja ? new Date(this.data.datumRodjenja) : null, Validators.required],
    semestar: [this.data?.semestar ?? '', Validators.required]
  });

  ngAfterViewInit() {
    this.form.updateValueAndValidity();
    this.cdr.detectChanges();
  }

  onEnter(event: Event) {
    const target = event.target as HTMLElement;
    if (target.tagName === 'TEXTAREA' || target.tagName === 'MAT-SELECT') return;
    this.submit();
  }

  submit() {
    if (this.form.invalid) return;

    const datumValue = this.form.value.datumRodjenja as Date | null;
    const datumStr = datumValue ? datumValue.toISOString().split('T')[0] : '';

    const imeRaw = this.form.value.ime!;
    const request = {
      brojIndeksa: this.data?.brojIndeksa ?? this.form.getRawValue().brojIndeksa!,
      ime: imeRaw.charAt(0).toUpperCase() + imeRaw.slice(1),
      datumRodjenja: datumStr,
      semestar: this.form.value.semestar!
    };

    const call: Observable<unknown> = this.data
      ? this.service.update(this.data.brojIndeksa, request)
      : this.service.create(request);

    call.subscribe({
      next: () => this.dialogRef.close(true),
      error: (err: any) => {
        this.errorMessage.set(err.error?.message ?? 'Greška pri čuvanju');
      }
    });
  }
}
