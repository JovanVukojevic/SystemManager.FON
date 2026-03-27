import { Injectable } from '@angular/core';
import { NativeDateAdapter } from '@angular/material/core';

@Injectable()
export class SrLatnDateAdapter extends NativeDateAdapter {
  override format(date: Date, displayFormat: Intl.DateTimeFormatOptions): string {
    return super.format(date, displayFormat).replace(/\.\s+/g, '.');
  }

  override parse(value: any): Date | null {
    if (typeof value === 'string') {
      const match = value.trim().match(/^(\d{1,2})\.(\d{1,2})\.(\d{4})\.?$/);
      if (match) {
        const day = parseInt(match[1], 10);
        const month = parseInt(match[2], 10) - 1;
        const year = parseInt(match[3], 10);
        const date = new Date(year, month, day);
        if (!isNaN(date.getTime())) {
          return date;
        }
      }
    }
    return super.parse(value);
  }
}
