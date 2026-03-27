import { Component, inject, ChangeDetectionStrategy, signal, AfterViewInit, ChangeDetectorRef } from '@angular/core';
import { MAT_DIALOG_DATA, MatDialogModule, MatDialogRef } from '@angular/material/dialog';
import { ReactiveFormsModule, FormBuilder, Validators } from '@angular/forms';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';
import { MatButtonModule } from '@angular/material/button';
import { Observable } from 'rxjs';
import { PredmetService } from '../../../core/services/predmet.service';
import { PredmetResponse } from '../../../core/models/ispit.models';

@Component({
  selector: 'app-predmet-form',
  standalone: true,
  imports: [MatDialogModule, ReactiveFormsModule, MatFormFieldModule, MatInputModule, MatButtonModule],
  changeDetection: ChangeDetectionStrategy.OnPush,
  template: `
    <h2 mat-dialog-title>{{ data ? 'Izmeni predmet' : 'Dodaj predmet' }}</h2>
    <mat-dialog-content>
      <form [formGroup]="form" style="display: flex; flex-direction: column; gap: 8px; padding-top: 8px;" (keydown.enter)="onEnter($event)">
        <mat-form-field appearance="outline">
          <mat-label>Naziv</mat-label>
          <input matInput formControlName="naziv" />
          @if (form.controls.naziv.hasError('required')) {
            <mat-error>Naziv je obavezan</mat-error>
          } @else if (form.controls.naziv.hasError('minlength')) {
            <mat-error>Naziv mora imati najmanje 2 karaktera</mat-error>
          }
        </mat-form-field>

        <mat-form-field appearance="outline">
          <mat-label>ESPB</mat-label>
          <input matInput type="number" formControlName="espb" />
          @if (form.controls.espb.hasError('required')) {
            <mat-error>ESPB je obavezan</mat-error>
          } @else if (form.controls.espb.hasError('min')) {
            <mat-error>ESPB mora biti veći od 2</mat-error>
          } @else if (form.controls.espb.hasError('max')) {
            <mat-error>ESPB ne može biti veći od 12</mat-error>
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
export class PredmetFormComponent implements AfterViewInit {
  data = inject<PredmetResponse | null>(MAT_DIALOG_DATA);
  private dialogRef = inject(MatDialogRef<PredmetFormComponent>);
  private service = inject(PredmetService);
  private fb = inject(FormBuilder);

  errorMessage = signal<string | null>(null);
  private cdr = inject(ChangeDetectorRef);

  form = this.fb.group({
    naziv: [this.data?.naziv ?? '', [Validators.required, Validators.minLength(2)]],
    espb: [this.data?.espb ?? null, [Validators.required, Validators.min(3), Validators.max(12)]]
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
    const nazRaw = this.form.value.naziv!;
    const request = { naziv: nazRaw.charAt(0).toUpperCase() + nazRaw.slice(1), espb: this.form.value.espb! };

    const call: Observable<unknown> = this.data
      ? this.service.update(this.data.idPredmet, request)
      : this.service.create(request);

    call.subscribe({
      next: () => this.dialogRef.close(true),
      error: (err: any) => {
        this.errorMessage.set(err.error?.message ?? 'Greška pri čuvanju');
      }
    });
  }
}
