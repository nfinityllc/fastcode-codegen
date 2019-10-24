import { Component, Input } from '@angular/core';
import { ILineHeight, TLineHeight } from '../interfaces';

@Component({
  selector: 'ip-line-height',
  template: `
    <div class="group">
      <mat-form-field appearance="outline">
        <mat-label>Line Height</mat-label>
        <input matInput [(ngModel)]="lineHeight.value" type="number" step="1"
          placeholder="Line Height" [disabled]="lineHeight.unit === 'none'">
      </mat-form-field>
      <mat-form-field appearance="outline">
        <mat-label>Unit</mat-label>
        <mat-select placeholder="Unit" [(value)]="lineHeight.unit" disableRipple>
          <mat-option *ngFor="let unit of getLineHeights()" [value]="unit">
            {{getUnitLabel(unit)}}
          </mat-option>
        </mat-select>
      </mat-form-field>
    </div>
  `,
  styles: []
})
export class LineHeightComponent {
  @Input()
  lineHeight: ILineHeight;

  private units: Map<string, string> = new Map([
    ['%', 'Percents'],
    ['px', 'Pixels'],
    ['none', 'None']
  ]);

  getLineHeights(): TLineHeight[] {
    return ['%', 'px', 'none'];
  }

  getUnitLabel(unit: TLineHeight): string {
    return this.units.get(unit);
  }
}
