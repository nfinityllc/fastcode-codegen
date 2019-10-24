import { Component, Input } from '@angular/core';
import { TAlign } from '../interfaces';

@Component({
  selector: 'ip-align',
  template: `
    <mat-form-field appearance="outline">
      <mat-label>Align</mat-label>
      <mat-select placeholder="Align" [(value)]="model.align" disableRipple>
        <mat-option *ngFor="let position of getPositions()" [value]="position">
          {{position}}
        </mat-option>
      </mat-select>
    </mat-form-field>
  `
})
export class AlignComponent {
  @Input()
  model: { align: TAlign };
  constructor() {}

  getPositions(): TAlign[] {
    return ['left', 'center', 'right'];
  }
}
