import { Component, inject, ChangeDetectionStrategy, signal, OnInit, AfterViewInit, ChangeDetectorRef } from '@angular/core';
import { MAT_DIALOG_DATA, MatDialogModule, MatDialogRef } from '@angular/material/dialog';
import { ReactiveFormsModule, FormBuilder, Validators } from '@angular/forms';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';
import { MatSelectModule } from '@angular/material/select';
import { MatButtonModule } from '@angular/material/button';
import { MatProgressSpinnerModule } from '@angular/material/progress-spinner';
import { Observable } from 'rxjs';
import { NastavnikService } from '../../../core/services/nastavnik.service';
import { ZvanjeService } from '../../../core/services/zvanje.service';
import { NastavnikResponse, ZvanjeResponse } from '../../../core/models/ispit.models';
import { SearchableDropdownComponent } from '../../../shared/components/searchable-dropdown/searchable-dropdown.component';

@Component({
  selector: 'app-nastavnik-form',
  standalone: true,
  imports: [MatDialogModule, ReactiveFormsModule, MatFormFieldModule, MatInputModule, MatSelectModule, MatButtonModule, MatProgressSpinnerModule, SearchableDropdownComponent],
  changeDetection: ChangeDetectionStrategy.OnPush,
  template: `
    <h2 mat-dialog-title>{{ data ? 'Izmeni nastavnika' : 'Dodaj nastavnika' }}</h2>
    <mat-dialog-content>
      <form [formGroup]="form" style="display: flex; flex-direction: column; gap: 8px; padding-top: 8px;" (keydown.enter)="onEnter($event)">
        <mat-form-field appearance="outline">
          <mat-label>Ime</mat-label>
          <input matInput formControlName="ime" />
          @if (form.controls.ime.hasError('required')) {
            <mat-error>Ime je obavezno</mat-error>
          } @else if (form.controls.ime.hasError('minlength')) {
            <mat-error>Ime mora imati najmanje 2 karaktera</mat-error>
          }
        </mat-form-field>

        <app-searchable-dropdown
          formControlName="idZvanje"
          label="Zvanje"
          [options]="zvanja()"
          [displayFn]="zvanjeDisplayFn"
          [valueFn]="zvanjeValueFn"
        />

        @if (errorMessage()) {
          <p style="color: red; margin: 0;">{{ errorMessage() }}</p>
        }
      </form>
    </mat-dialog-content>
    <mat-dialog-actions align="end">
      <button mat-button mat-dialog-close>Otkaži</button>
      <button mat-raised-button color="primary" (click)="submit()" [disabled]="form.invalid || loadingZvanja()">Sačuvaj</button>
    </mat-dialog-actions>
  `
})
export class NastavnikFormComponent implements OnInit, AfterViewInit {
  data = inject<NastavnikResponse | null>(MAT_DIALOG_DATA);
  private dialogRef = inject(MatDialogRef<NastavnikFormComponent>);
  private service = inject(NastavnikService);
  private zvanjeService = inject(ZvanjeService);
  private fb = inject(FormBuilder);

  errorMessage = signal<string | null>(null);
  zvanja = signal<ZvanjeResponse[]>([]);
  loadingZvanja = signal(true);
  private cdr = inject(ChangeDetectorRef);

  zvanjeDisplayFn = (z: ZvanjeResponse) => z.naziv;
  zvanjeValueFn = (z: ZvanjeResponse) => z.idZvanje;

  form = this.fb.group({
    ime: [this.data?.ime ?? '', [Validators.required, Validators.minLength(2)]],
    idZvanje: [this.data?.zvanje?.idZvanje ?? null, Validators.required]
  });

  ngAfterViewInit() {
    this.form.updateValueAndValidity();
    this.cdr.detectChanges();
  }

  ngOnInit() {
    this.zvanjeService.getAll().subscribe({
      next: (data) => {
        this.zvanja.set(data);
        this.loadingZvanja.set(false);
      },
      error: () => this.loadingZvanja.set(false)
    });
  }

  onEnter(event: Event) {
    const target = event.target as HTMLElement;
    if (target.tagName === 'TEXTAREA' || target.tagName === 'MAT-SELECT') return;
    this.submit();
  }

  submit() {
    if (this.form.invalid) return;
    const imeRaw = this.form.value.ime!;
    const request = { ime: imeRaw.charAt(0).toUpperCase() + imeRaw.slice(1), idZvanje: this.form.value.idZvanje! };

    const call: Observable<unknown> = this.data
      ? this.service.update(this.data.idNastavnik, request)
      : this.service.create(request);

    call.subscribe({
      next: () => this.dialogRef.close(true),
      error: (err: any) => {
        this.errorMessage.set(err.error?.message ?? 'Greška pri čuvanju');
      }
    });
  }
}
