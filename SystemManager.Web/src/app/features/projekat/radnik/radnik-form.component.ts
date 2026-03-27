import { Component, inject, ChangeDetectionStrategy, signal, OnInit, AfterViewInit, ChangeDetectorRef } from '@angular/core';
import { MAT_DIALOG_DATA, MatDialogModule, MatDialogRef } from '@angular/material/dialog';
import { ReactiveFormsModule, FormBuilder, Validators, FormArray, FormGroup } from '@angular/forms';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';
import { MatSelectModule } from '@angular/material/select';
import { MatDatepickerModule } from '@angular/material/datepicker';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';
import { forkJoin, Observable } from 'rxjs';
import { RadnikService } from '../../../core/services/radnik.service';
import { RadnoMestoService } from '../../../core/services/radnomesto.service';
import { SluzbaService } from '../../../core/services/sluzba.service';
import { ProjekatService } from '../../../core/services/projekat.service';
import { RadnikResponse, RadnoMestoResponse, SluzbaResponse, ProjekatResponse } from '../../../core/models/projekat.models';
import { SearchableDropdownComponent } from '../../../shared/components/searchable-dropdown/searchable-dropdown.component';

@Component({
  selector: 'app-radnik-form',
  standalone: true,
  imports: [
    MatDialogModule, ReactiveFormsModule, MatFormFieldModule,
    MatInputModule, MatSelectModule, MatDatepickerModule,
    MatButtonModule, MatIconModule, SearchableDropdownComponent
  ],
  changeDetection: ChangeDetectionStrategy.OnPush,
  template: `
    <h2 mat-dialog-title>{{ data ? 'Izmeni radnika' : 'Dodaj radnika' }}</h2>
    <mat-dialog-content style="min-width: 600px;">
      @if (loading()) {
        <p style="padding: 16px 0;">Učitavanje podataka...</p>
      } @else {
        <form [formGroup]="form" style="display: flex; flex-direction: column; gap: 8px; padding-top: 8px;" (keydown.enter)="onEnter($event)">
          <mat-form-field appearance="outline">
            <mat-label>Ime</mat-label>
            <input matInput formControlName="ime" />
            @if (form.controls.ime.hasError('required')) {
              <mat-error>Ime je obavezno</mat-error>
            }
            @if (form.controls.ime.hasError('minlength')) {
              <mat-error>Ime mora imati najmanje 2 karaktera</mat-error>
            }
          </mat-form-field>

          <app-searchable-dropdown
            formControlName="radnoMestoId"
            label="Radno mesto"
            [options]="radnaMesta()"
            [displayFn]="radnoMestoDisplayFn"
            [valueFn]="radnoMestoValueFn"
          />

          <app-searchable-dropdown
            formControlName="sluzbaId"
            label="Služba"
            [options]="sluzbe()"
            [displayFn]="sluzbaDisplayFn"
            [valueFn]="sluzbaValueFn"
          />

          <div style="margin-top: 8px;">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 8px;">
              <strong>Projekti</strong>
              <button mat-stroked-button type="button" (click)="addProjekat()">
                <mat-icon>add</mat-icon> Dodaj projekat
              </button>
            </div>

            @for (row of projektiArray.controls; track $index) {
              <div [formGroup]="asGroup(row)" style="display: flex; gap: 8px; align-items: flex-start; margin-bottom: 4px;">
                <app-searchable-dropdown
                  formControlName="projekatId"
                  label="Projekat"
                  [options]="projekti()"
                  [displayFn]="projekatDisplayFn"
                  [valueFn]="projekatValueFn"
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

                <button mat-icon-button color="warn" type="button" (click)="removeProjekat($index)" style="margin-top: 8px;">
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
export class RadnikFormComponent implements OnInit, AfterViewInit {
  data = inject<RadnikResponse | null>(MAT_DIALOG_DATA);
  private dialogRef = inject(MatDialogRef<RadnikFormComponent>);
  private service = inject(RadnikService);
  private radnoMestoService = inject(RadnoMestoService);
  private sluzbaService = inject(SluzbaService);
  private projekatService = inject(ProjekatService);
  private fb = inject(FormBuilder);

  errorMessage = signal<string | null>(null);
  loading = signal(true);
  radnaMesta = signal<RadnoMestoResponse[]>([]);
  sluzbe = signal<SluzbaResponse[]>([]);
  projekti = signal<ProjekatResponse[]>([]);
  private cdr = inject(ChangeDetectorRef);

  radnoMestoDisplayFn = (rm: RadnoMestoResponse) => rm.naziv;
  radnoMestoValueFn = (rm: RadnoMestoResponse) => rm.radnoMestoId;
  sluzbaDisplayFn = (s: SluzbaResponse) => s.naziv;
  sluzbaValueFn = (s: SluzbaResponse) => s.sluzbaId;
  projekatDisplayFn = (p: ProjekatResponse) => p.naziv;
  projekatValueFn = (p: ProjekatResponse) => p.projekatId;

  form = this.fb.group({
    ime: [this.data?.ime ?? '', [Validators.required, Validators.minLength(2)]],
    radnoMestoId: [this.data?.radnoMesto?.radnoMestoId ?? null, Validators.required],
    sluzbaId: [this.data?.sluzba?.sluzbaId ?? null, Validators.required],
    projekti: this.fb.array([])
  });

  ngAfterViewInit() {
    this.form.updateValueAndValidity();
    this.cdr.detectChanges();
  }

  get projektiArray(): FormArray {
    return this.form.get('projekti') as FormArray;
  }

  asGroup(ctrl: any): FormGroup {
    return ctrl as FormGroup;
  }

  ngOnInit() {
    forkJoin({
      radnaMesta: this.radnoMestoService.getAll(),
      sluzbe: this.sluzbaService.getAll(),
      projekti: this.projekatService.getAll()
    }).subscribe({
      next: ({ radnaMesta, sluzbe, projekti }) => {
        this.radnaMesta.set(radnaMesta);
        this.sluzbe.set(sluzbe);
        this.projekti.set(projekti);
        if (this.data?.projekti) {
          this.data.projekti.forEach(p => {
            this.projektiArray.push(this.fb.group({
              projekatId: [p.projekatId, Validators.required],
              datumOd: [p.datumOd ? new Date(p.datumOd) : null, Validators.required],
              datumDo: [p.datumDo ? new Date(p.datumDo) : null]
            }));
          });
        }
        this.loading.set(false);
      },
      error: () => this.loading.set(false)
    });
  }

  addProjekat() {
    this.projektiArray.push(this.fb.group({
      projekatId: [null, Validators.required],
      datumOd: [null, Validators.required],
      datumDo: [null]
    }));
  }

  removeProjekat(index: number) {
    this.projektiArray.removeAt(index);
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

    const projektiPayload = this.projektiArray.controls.map(ctrl => {
      const g = ctrl as FormGroup;
      return {
        projekatId: g.value.projekatId as number,
        datumOd: this.toDateStr(g.value.datumOd) ?? '',
        datumDo: this.toDateStr(g.value.datumDo) ?? undefined
      };
    });

    const imeRaw = this.form.value.ime!;
    const request = {
      ime: imeRaw.charAt(0).toUpperCase() + imeRaw.slice(1),
      radnoMestoId: this.form.value.radnoMestoId!,
      sluzbaId: this.form.value.sluzbaId!,
      projekti: projektiPayload
    };

    const call: Observable<unknown> = this.data
      ? this.service.update(this.data.radnikId, request)
      : this.service.create(request);

    call.subscribe({
      next: () => this.dialogRef.close(true),
      error: (err: any) => {
        this.errorMessage.set(err.error?.message ?? 'Greška pri čuvanju');
      }
    });
  }
}
