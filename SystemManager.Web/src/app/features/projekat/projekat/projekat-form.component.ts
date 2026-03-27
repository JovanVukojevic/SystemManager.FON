import { Component, inject, ChangeDetectionStrategy, signal, OnInit, AfterViewInit, ChangeDetectorRef, DestroyRef } from '@angular/core';
import { takeUntilDestroyed } from '@angular/core/rxjs-interop';
import { MAT_DIALOG_DATA, MatDialogModule, MatDialogRef } from '@angular/material/dialog';
import { ReactiveFormsModule, FormBuilder, Validators, FormArray, FormGroup } from '@angular/forms';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';
import { MatSelectModule } from '@angular/material/select';
import { MatDatepickerModule } from '@angular/material/datepicker';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';
import { Observable } from 'rxjs';
import { ProjekatService } from '../../../core/services/projekat.service';
import { RadnikService } from '../../../core/services/radnik.service';
import { ProjekatResponse, RadnikResponse } from '../../../core/models/projekat.models';
import { SearchableDropdownComponent } from '../../../shared/components/searchable-dropdown/searchable-dropdown.component';

@Component({
  selector: 'app-projekat-form',
  standalone: true,
  imports: [
    MatDialogModule, ReactiveFormsModule, MatFormFieldModule,
    MatInputModule, MatSelectModule, MatDatepickerModule,
    MatButtonModule, MatIconModule, SearchableDropdownComponent
  ],
  changeDetection: ChangeDetectionStrategy.OnPush,
  template: `
    <h2 mat-dialog-title>{{ data ? 'Izmeni projekat' : 'Dodaj projekat' }}</h2>
    <mat-dialog-content style="min-width: 760px; max-height: none;">
      @if (loading()) {
        <p style="padding: 16px 0;">Učitavanje podataka...</p>
      } @else {
        <form [formGroup]="form" style="display: flex; flex-direction: column; gap: 8px; padding-top: 8px;" (keydown.enter)="onEnter($event)">
          <mat-form-field appearance="outline">
            <mat-label>Naziv</mat-label>
            <input matInput formControlName="naziv" />
            @if (form.controls.naziv.hasError('required')) {
              <mat-error>Naziv je obavezan</mat-error>
            }
          </mat-form-field>

          <mat-form-field appearance="outline">
            <mat-label>Budzet</mat-label>
            <input matInput type="number" formControlName="budzet" />
            @if (form.controls.budzet.hasError('required')) {
              <mat-error>Budzet je obavezan</mat-error>
            }
            @if (form.controls.budzet.hasError('min')) {
              <mat-error>Budžet mora biti veći od 0</mat-error>
            }
          </mat-form-field>

          <app-searchable-dropdown
            formControlName="rukovodiRadnikId"
            label="Rukovodi radnik (opciono)"
            [options]="radnici()"
            [displayFn]="radnikDisplayFn"
            [valueFn]="radnikValueFn"
            [filterFn]="radnikFilterFn"
            [nullable]="true"
            nullLabel="— Bez rukovodioca —"
          />

          <div style="margin-top: 8px;">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 8px;">
              <strong>Radnici na projektu</strong>
              <button mat-stroked-button type="button" (click)="addRadnik()">
                <mat-icon>add</mat-icon> Dodaj radnika
              </button>
            </div>

            @for (row of radniciArray.controls; track $index) {
              <div [formGroup]="asGroup(row)" style="display: flex; gap: 8px; align-items: flex-start; margin-bottom: 4px;">
                <app-searchable-dropdown
                  formControlName="radnikId"
                  label="Radnik"
                  [options]="radnici()"
                  [displayFn]="radnikDisplayFn"
                  [valueFn]="radnikValueFn"
                  [filterFn]="radnikFilterFn"
                  style="flex: 2;"
                />

                <mat-form-field appearance="outline" style="flex: 2; min-width: 150px;">
                  <mat-label>Od</mat-label>
                  <input matInput [matDatepicker]="pickerOd" formControlName="datumOd" />
                  <mat-datepicker-toggle matIconSuffix [for]="pickerOd" />
                  <mat-datepicker #pickerOd />
                </mat-form-field>

                <mat-form-field appearance="outline" style="flex: 2; min-width: 150px;">
                  <mat-label>Do (opciono)</mat-label>
                  <input matInput [matDatepicker]="pickerDo" formControlName="datumDo" />
                  <mat-datepicker-toggle matIconSuffix [for]="pickerDo" />
                  <mat-datepicker #pickerDo />
                </mat-form-field>

                <button mat-icon-button color="warn" type="button" (click)="removeRadnik($index)" style="margin-top: 8px;">
                  <mat-icon>remove_circle</mat-icon>
                </button>
              </div>
            }
          </div>

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
export class ProjekatFormComponent implements OnInit, AfterViewInit {
  data = inject<ProjekatResponse | null>(MAT_DIALOG_DATA);
  private dialogRef = inject(MatDialogRef<ProjekatFormComponent>);
  private service = inject(ProjekatService);
  private radnikService = inject(RadnikService);
  private fb = inject(FormBuilder);

  errorMessage = signal<string | null>(null);
  loading = signal(true);
  radnici = signal<RadnikResponse[]>([]);
  private cdr = inject(ChangeDetectorRef);
  private destroyRef = inject(DestroyRef);

  radnikDisplayFn = (r: RadnikResponse) => `${r.ime} (${r.radnoMesto.naziv} - ${r.sluzba.naziv})`;
  radnikValueFn = (r: RadnikResponse) => r.radnikId;
  radnikFilterFn = (r: RadnikResponse, q: string) => {
    const lower = q.toLowerCase();
    return r.ime.toLowerCase().includes(lower)
      || r.radnoMesto.naziv.toLowerCase().includes(lower)
      || r.sluzba.naziv.toLowerCase().includes(lower);
  };

  form = this.fb.group({
    naziv: [this.data?.naziv ?? 'PR-', Validators.required],
    budzet: [this.data?.budzet ?? null, [Validators.required, Validators.min(1)]],
    rukovodiRadnikId: [this.data?.rukovodiRadnikId ?? null],
    radnici: this.fb.array([])
  });

  ngAfterViewInit() {
    this.form.updateValueAndValidity();
    this.cdr.detectChanges();
  }

  get radniciArray(): FormArray {
    return this.form.get('radnici') as FormArray;
  }

  asGroup(ctrl: any): FormGroup {
    return ctrl as FormGroup;
  }

  ngOnInit() {
    if (!this.data) {
      this.form.controls.naziv.valueChanges
        .pipe(takeUntilDestroyed(this.destroyRef))
        .subscribe(value => {
          if (!value?.startsWith('PR-')) {
            this.form.controls.naziv.setValue('PR-', { emitEvent: false });
          }
        });
    }

    this.radnikService.getAll().subscribe({
      next: (data) => {
        this.radnici.set(data);
        if (this.data?.radnici) {
          this.data.radnici.forEach(r => {
            this.radniciArray.push(this.fb.group({
              radnikId: [r.radnikId, Validators.required],
              datumOd: [r.datumOd ? new Date(r.datumOd) : null, Validators.required],
              datumDo: [r.datumDo ? new Date(r.datumDo) : null]
            }));
          });
        }
        this.loading.set(false);
      },
      error: () => this.loading.set(false)
    });
  }

  addRadnik() {
    this.radniciArray.push(this.fb.group({
      radnikId: [null, Validators.required],
      datumOd: [null, Validators.required],
      datumDo: [null]
    }));
  }

  removeRadnik(index: number) {
    this.radniciArray.removeAt(index);
  }

  private toDateStr(val: Date | string | null | undefined): string | null {
    if (!val) return null;
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

    const radniciPayload = this.radniciArray.controls.map(ctrl => {
      const g = ctrl as FormGroup;
      return {
        radnikId: g.value.radnikId as number,
        datumOd: this.toDateStr(g.value.datumOd) ?? '',
        datumDo: this.toDateStr(g.value.datumDo) ?? undefined
      };
    });

    const nazRaw = this.form.value.naziv!;
    const request = {
      naziv: nazRaw.length > 3 ? 'PR-' + nazRaw.charAt(3).toUpperCase() + nazRaw.slice(4) : nazRaw,
      budzet: this.form.value.budzet!,
      rukovodiRadnikId: this.form.value.rukovodiRadnikId ?? undefined,
      radnici: radniciPayload
    };

    const call: Observable<unknown> = this.data
      ? this.service.update(this.data.projekatId, request)
      : this.service.create(request);

    call.subscribe({
      next: () => this.dialogRef.close(true),
      error: (err: any) => {
        this.errorMessage.set(err.error?.message ?? 'Greška pri čuvanju');
      }
    });
  }
}
