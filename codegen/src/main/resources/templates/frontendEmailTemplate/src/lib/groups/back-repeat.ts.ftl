import { Component, Input } from '@angular/core';
import { TBackgroundRepeat } from '../interfaces';

@Component({
  selector: 'ip-back-repeat',
  template: `
    <mat-form-field appearance="outline">
      <mat-label>Repeat</mat-label>
      <mat-select placeholder="Background Repeat" [(value)]="model.repeat" disableRipple>
        <mat-option *ngFor="let repeat of getRepeats()" [value]="repeat">
          {{getRepeatLabel(repeat)}}
        </mat-option>
      </mat-select>
    </mat-form-field>
  `
})
export class BackRepatComponent {
  @Input()
  model: { repeat: TBackgroundRepeat };

  private repeatLabels: Map<string, string> = new Map([
    ['no-repeat', 'No Repeat'],
    ['repeat', 'Repeat'],
    ['repeat-x', 'Repeat X'],
    ['repeat-y', 'Repeat Y'],
    ['round', 'Round'],
    ['space', 'Space']
  ]);

  constructor() {}

  getRepeats(): TBackgroundRepeat[] {
    return ['no-repeat', 'repeat', 'repeat-x', 'repeat-y', 'round', 'space'];
  }

  getRepeatLabel(repeat: TBackgroundRepeat): string {
    return this.repeatLabels.get(repeat);
  }
}
