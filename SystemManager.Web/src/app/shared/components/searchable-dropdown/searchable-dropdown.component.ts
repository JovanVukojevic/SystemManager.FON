import {
  Component,
  ChangeDetectionStrategy,
  Input,
  OnChanges,
  SimpleChanges,
  input,
  signal,
  computed,
  viewChild,
  forwardRef,
  ElementRef,
  effect,
  untracked,
} from '@angular/core';
import { ControlValueAccessor, NG_VALUE_ACCESSOR, ReactiveFormsModule, FormControl } from '@angular/forms';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';
import { MatAutocompleteModule, MatAutocompleteTrigger } from '@angular/material/autocomplete';
import { MatIconModule } from '@angular/material/icon';
import { MatButtonModule } from '@angular/material/button';

const NO_PENDING = Symbol('no_pending');

@Component({
  selector: 'app-searchable-dropdown',
  standalone: true,
  imports: [
    ReactiveFormsModule,
    MatFormFieldModule,
    MatInputModule,
    MatAutocompleteModule,
    MatIconModule,
    MatButtonModule,
  ],
  providers: [
    {
      provide: NG_VALUE_ACCESSOR,
      useExisting: forwardRef(() => SearchableDropdownComponent),
      multi: true,
    },
  ],
  changeDetection: ChangeDetectionStrategy.OnPush,
  template: `
    <mat-form-field appearance="outline" style="width: 100%;">
      <mat-label>{{ label() }}</mat-label>
      <input
        matInput
        [formControl]="inputControl"
        [matAutocomplete]="auto"
        (blur)="onBlur()"
        #inputEl
      />
      <button
        matSuffix
        mat-icon-button
        type="button"
        tabindex="-1"
        (click)="togglePanel($event)"
      >
        <mat-icon>arrow_drop_down</mat-icon>
      </button>
      <mat-autocomplete
        #auto="matAutocomplete"
        [displayWith]="identityDisplayFn"
        (optionSelected)="onOptionSelected($event.option.value)"
      >
        @if (nullable()) {
          <mat-option [value]="NULLABLE_SENTINEL">{{ nullLabel() }}</mat-option>
        }
        @for (opt of filteredOptions(); track trackByValue(opt)) {
          <mat-option [value]="valueFn()(opt)">{{ displayFn()(opt) }}</mat-option>
        }
      </mat-autocomplete>
    </mat-form-field>
  `,
})
export class SearchableDropdownComponent implements ControlValueAccessor, OnChanges {
  readonly NULLABLE_SENTINEL = '__NULL__';

  @Input() options: any[] = [];
  private _optionsSignal = signal<any[]>([]);

  displayFn = input<(item: any) => string>(() => '');
  valueFn = input<(item: any) => any>(() => null);
  filterFn = input<((item: any, query: string) => boolean) | null>(null);
  label = input('');
  nullable = input(false);
  nullLabel = input('— Nema —');

  inputControl = new FormControl('');
  private currentValue = signal<any>(null);
  private _pendingValue: typeof NO_PENDING | any = NO_PENDING;
  private searchText = signal('');

  private trigger = viewChild(MatAutocompleteTrigger);
  private inputEl = viewChild<ElementRef>('inputEl');

  private onChange: (value: any) => void = () => {};
  private onTouched: () => void = () => {};
  private _blurTimer?: ReturnType<typeof setTimeout>;

  filteredOptions = computed(() => {
    const opts = this._optionsSignal();
    const query = this.searchText();
    if (!query) return opts;
    const customFilter = this.filterFn();
    if (customFilter) {
      return opts.filter((item) => customFilter(item, query));
    }
    const display = this.displayFn();
    const lower = query.toLowerCase();
    return opts.filter((item) => display(item).toLowerCase().includes(lower));
  });

  identityDisplayFn = (value: any): string => {
    if (value == null || value === this.NULLABLE_SENTINEL) return '';
    return typeof value === 'string' ? value : String(value);
  };

  private getDisplayForValue(value: any): string {
    if (value === this.NULLABLE_SENTINEL || value == null) return '';
    const opts = this._optionsSignal();
    const valFn = this.valueFn();
    const dispFn = this.displayFn();
    const match = opts.find((item) => valFn(item) === value);
    return match ? dispFn(match) : '';
  }

  constructor() {
    this.inputControl.valueChanges.subscribe((val) => {
      if (typeof val === 'string') {
        this.searchText.set(val);
      }
    });

    effect(() => {
      const val = this.currentValue();
      if (val == null) {
        this.inputControl.setValue('', { emitEvent: false });
        return;
      }
      const opts = untracked(() => this._optionsSignal());
      const valFn = this.valueFn();
      const dispFn = this.displayFn();
      const match = opts.find((item) => valFn(item) === val);
      if (match) {
        this.inputControl.setValue(dispFn(match), { emitEvent: false });
      }
    });
  }

  ngOnChanges(changes: SimpleChanges): void {
    if (changes['options']) {
      this._optionsSignal.set(this.options ?? []);

      if (this.options.length > 0 && this._pendingValue !== NO_PENDING) {
        const val = this._pendingValue;
        this._pendingValue = NO_PENDING;
        const display = this.getDisplayForValue(val);
        if (display) {
          this.inputControl.setValue(display, { emitEvent: false });
        }
      }
    }
  }

  trackByValue(opt: any): any {
    return this.valueFn()(opt);
  }

  togglePanel(event: Event) {
    event.stopPropagation();
    const t = this.trigger();
    if (t) {
      if (t.panelOpen) {
        t.closePanel();
      } else {
        this.inputEl()?.nativeElement?.focus();
        t.openPanel();
      }
    }
  }

  onOptionSelected(value: any) {
    clearTimeout(this._blurTimer);
    if (value === this.NULLABLE_SENTINEL) {
      this.currentValue.set(null);
      this.onChange(null);
      this.inputControl.setValue('', { emitEvent: false });
    } else {
      this.currentValue.set(value);
      this.onChange(value);
      const display = this.getDisplayForValue(value);
      this.inputControl.setValue(display, { emitEvent: false });
    }
    this.searchText.set('');
  }

  onBlur() {
    this.onTouched();
    this._blurTimer = setTimeout(() => {
      const val = this.currentValue();
      const display = val != null ? this.getDisplayForValue(val) : '';
      this.inputControl.setValue(display, { emitEvent: false });
      this.searchText.set('');
    }, 150);
  }

  writeValue(value: any): void {
    if (value === null || value === undefined) {
      this.currentValue.set(null);
      this._pendingValue = NO_PENDING;
      return;
    }

    if (this.options.length > 0) {
      this.currentValue.set(value);
      this._pendingValue = NO_PENDING;
    } else {
      this._pendingValue = value;
      this.currentValue.set(value);
    }
  }

  registerOnChange(fn: (value: any) => void): void {
    this.onChange = fn;
  }

  registerOnTouched(fn: () => void): void {
    this.onTouched = fn;
  }

  setDisabledState(isDisabled: boolean): void {
    if (isDisabled) {
      this.inputControl.disable({ emitEvent: false });
    } else {
      this.inputControl.enable({ emitEvent: false });
    }
  }
}
