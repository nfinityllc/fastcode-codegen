import { Component, Input } from '@angular/core';
import { TDirection } from '../interfaces';

@Component({
  selector: 'ip-direction',
  template: `
    <mat-form-field appearance="outline">
      <mat-label>Direction</mat-label>
      <mat-select placeholder="Direction" [(value)]="model.direction" disableRipple>
        <mat-option *ngFor="let dir of getDirections()" [value]="dir">
          {{getDirectionLabel(dir)}}
        </mat-option>
      </mat-select>
    </mat-form-field>
  `
})
export class DirectionComponent {
  @Input()
  model: {
    direction: TDirection;
  };

  private dirLabels: Map<string, string> = new Map([
    ['ltr', 'Left to Right'],
    ['rtl', 'Right to Left']
  ]);

  getDirections(): TDirection[] {
    return ['ltr', 'rtl'];
  }

  getDirectionLabel(dir: TDirection): string {
    return this.dirLabels.get(dir);
  }
}
