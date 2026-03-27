import { Component, inject, ChangeDetectionStrategy, signal, AfterViewInit, ChangeDetectorRef } from '@angular/core';
import { MAT_DIALOG_DATA, MatDialogModule, MatDialogRef } from '@angular/material/dialog';
import { ReactiveFormsModule, FormBuilder, Validators } from '@angular/forms';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';
import { MatButtonModule } from '@angular/material/button';
import { Observable } from 'rxjs';
import { SluzbaService } from '../../../core/services/sluzba.service';
import { SluzbaResponse } from '../../../core/models/projekat.models';

@Component({
  selector: 'app-sluzba-form',
  standalone: true,
  imports: [MatDialogModule, ReactiveFormsModule, MatFormFieldModule, MatInputModule, MatButtonModule],
  changeDetection: ChangeDetectionStrategy.OnPush,
  template: `
    <h2 mat-dialog-title>{{ data ? 'Izmeni službu' : 'Dodaj službu' }}</h2>
    <mat-dialog-content>
      <form [formGroup]="form" style="padding-top: 8px;" (keydown.enter)="onEnter($event)">
        <mat-form-field appearance="outline" style="width: 100%;">
          <mat-label>Naziv</mat-label>
          <input matInput formControlName="naziv" />
          @if (form.controls.naziv.hasError('required')) {
            <mat-error>Naziv je obavezan</mat-error>
          } @else if (form.controls.naziv.hasError('minlength')) {
            <mat-error>Naziv mora imati najmanje 2 karaktera</mat-error>
          }
        </mat-form-field>
        @if (errorMessage()) {
          <p style="color: red; margin-top: 4px;">{{ errorMessage() }}</p>
        }
      </form>
    </mat-dialog-content>
    <mat-dialog-actions align="end">
      <button mat-button mat-dialog-close>Otkaži</button>
      <button mat-raised-button color="primary" (click)="submit()" [disabled]="form.invalid">Sačuvaj</button>
    </mat-dialog-actions>
  `
})
export class SluzbaFormComponent implements AfterViewInit {
  data = inject<SluzbaResponse | null>(MAT_DIALOG_DATA);
  private dialogRef = inject(MatDialogRef<SluzbaFormComponent>);
  private service = inject(SluzbaService);
  private fb = inject(FormBuilder);

  errorMessage = signal<string | null>(null);
  private cdr = inject(ChangeDetectorRef);

  form = this.fb.group({
    naziv: [this.data?.naziv ?? '', [Validators.required, Validators.minLength(2)]]
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
    const request = { naziv: nazRaw.charAt(0).toUpperCase() + nazRaw.slice(1) };

    const call: Observable<unknown> = this.data
      ? this.service.update(this.data.sluzbaId, request)
      : this.service.create(request);

    call.subscribe({
      next: () => this.dialogRef.close(true),
      error: (err: any) => {
        this.errorMessage.set(err.error?.message ?? 'Greška pri čuvanju');
      }
    });
  }
}
