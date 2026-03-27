import { Component, inject, ChangeDetectionStrategy, signal, AfterViewInit, ChangeDetectorRef } from '@angular/core';
import { MAT_DIALOG_DATA, MatDialogModule, MatDialogRef } from '@angular/material/dialog';
import { ReactiveFormsModule, FormBuilder, Validators } from '@angular/forms';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';
import { MatSelectModule } from '@angular/material/select';
import { MatDatepickerModule } from '@angular/material/datepicker';
import { MatButtonModule } from '@angular/material/button';
import { Observable } from 'rxjs';
import { IsplataService } from '../../../core/services/isplata.service';
import { IsplataResponse } from '../../../core/models/projekat.models';

export interface IsplataFormData {
  radnikId: number;
  isplata: IsplataResponse | null;
}

@Component({
  selector: 'app-isplata-form',
  standalone: true,
  imports: [
    MatDialogModule, ReactiveFormsModule, MatFormFieldModule,
    MatInputModule, MatSelectModule, MatDatepickerModule,
    MatButtonModule
  ],
  changeDetection: ChangeDetectionStrategy.OnPush,
  template: `
    <h2 mat-dialog-title>{{ data.isplata ? 'Izmeni isplatu' : 'Dodaj isplatu' }}</h2>
    <mat-dialog-content style="min-width: 400px;">
      <form [formGroup]="form" style="display: flex; flex-direction: column; gap: 8px; padding-top: 8px;" (keydown.enter)="onEnter($event)">
        <mat-form-field appearance="outline">
          <mat-label>Vrsta</mat-label>
          <mat-select formControlName="vrsta">
            @for (v of vrste; track v) {
              <mat-option [value]="v">{{ v }}</mat-option>
            }
          </mat-select>
          @if (form.controls.vrsta.hasError('required')) {
            <mat-error>Vrsta je obavezna</mat-error>
          }
        </mat-form-field>

        <mat-form-field appearance="outline">
          <mat-label>Datum</mat-label>
          <input matInput [matDatepicker]="picker" formControlName="datum" />
          <mat-datepicker-toggle matIconSuffix [for]="picker" />
          <mat-datepicker #picker />
          @if (form.controls.datum.hasError('required')) {
            <mat-error>Datum je obavezan</mat-error>
          }
        </mat-form-field>

        <mat-form-field appearance="outline">
          <mat-label>Iznos</mat-label>
          <input matInput type="number" formControlName="iznos" />
          @if (form.controls.iznos.hasError('required')) {
            <mat-error>Iznos je obavezan</mat-error>
          }
          @if (form.controls.iznos.hasError('min')) {
            <mat-error>Iznos mora biti veći od 0</mat-error>
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
export class IsplataFormComponent implements AfterViewInit {
  data = inject<IsplataFormData>(MAT_DIALOG_DATA);
  private dialogRef = inject(MatDialogRef<IsplataFormComponent>);
  private service = inject(IsplataService);
  private fb = inject(FormBuilder);

  errorMessage = signal<string | null>(null);
  vrste = ['PLATA', 'BONUS', 'REGRES'];
  private cdr = inject(ChangeDetectorRef);

  form = this.fb.group({
    vrsta: [this.data.isplata?.vrsta ?? '', Validators.required],
    datum: [this.data.isplata?.datum ? new Date(this.data.isplata.datum) : new Date(), Validators.required],
    iznos: [this.data.isplata?.iznos ?? null, [Validators.required, Validators.min(1)]]
  });

  ngAfterViewInit() {
    this.form.updateValueAndValidity();
    this.cdr.detectChanges();
  }

  private toDateStr(val: Date | string | null | undefined): string {
    if (!val) return '';
    if (val instanceof Date) return val.toISOString().split('T')[0];
    return val.toString().split('T')[0];
  }

  onEnter(event: Event) {
    const target = event.target as HTMLElement;
    if (target.tagName === 'TEXTAREA' || target.tagName === 'MAT-SELECT') return;
    this.submit();
  }

  submit() {
    if (this.form.invalid) return;

    const request = {
      vrsta: this.form.value.vrsta!,
      datum: this.toDateStr(this.form.value.datum),
      iznos: this.form.value.iznos!
    };

    const call: Observable<unknown> = this.data.isplata
      ? this.service.update(this.data.radnikId, this.data.isplata.isplataId, request)
      : this.service.create(this.data.radnikId, request);

    call.subscribe({
      next: () => this.dialogRef.close(true),
      error: (err: any) => {
        this.errorMessage.set(err.error?.message ?? 'Greška pri čuvanju');
      }
    });
  }
}
