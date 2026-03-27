import { Component, ChangeDetectionStrategy, input, output } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';
import { MatIconModule } from '@angular/material/icon';
import { MatButtonModule } from '@angular/material/button';

@Component({
  selector: 'app-text-search',
  standalone: true,
  imports: [FormsModule, MatFormFieldModule, MatInputModule, MatIconModule, MatButtonModule],
  changeDetection: ChangeDetectionStrategy.OnPush,
  template: `
    <mat-form-field appearance="outline" subscriptSizing="dynamic">
      <mat-icon matPrefix>search</mat-icon>
      <input matInput
        [placeholder]="placeholder()"
        [ngModel]="value()"
        (ngModelChange)="onInput($event)">
      @if (value()) {
        <button matSuffix mat-icon-button (click)="clear()">
          <mat-icon>close</mat-icon>
        </button>
      }
    </mat-form-field>
  `,
  styles: [`
    mat-form-field { width: 250px; }
    mat-icon[matPrefix] { margin-right: 4px; }
  `]
})
export class TextSearchComponent {
  placeholder = input('Pretraga...');
  value = input('');
  searchChange = output<string>();

  onInput(val: string) {
    this.searchChange.emit(val);
  }

  clear() {
    this.searchChange.emit('');
  }
}
