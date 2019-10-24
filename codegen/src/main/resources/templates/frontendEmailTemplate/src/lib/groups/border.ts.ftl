import { Component, Input } from '@angular/core';
import { IBorder } from '../interfaces';

@Component({
  selector: 'ip-border',
  template: `
    <div class="group" [ngClass]="{'three': !isEven()}">
      <mat-form-field appearance="outline" *ngIf="hasOwnProperty('width')">
        <mat-label>Border Width</mat-label>
        <input matInput [(ngModel)]="border.width" type="number" min="0" step="1" placeholder="Border Width">
      </mat-form-field>
      <mat-form-field appearance="outline" *ngIf="hasOwnProperty('style')">
        <mat-label>Style</mat-label>
        <mat-select placeholder="Style" [(value)]="border.style" disableRipple>
          <mat-option *ngFor="let style of ['solid', 'dashed', 'dotted']" [value]="style">
            {{style}}
          </mat-option>
        </mat-select>
      </mat-form-field>
      <ip-color [model]="border" *ngIf="hasOwnProperty('color')"></ip-color>
      <mat-form-field appearance="outline" *ngIf="hasOwnProperty('radius')">
        <mat-label>Radius</mat-label>
        <input matInput [(ngModel)]="border.radius" type="number" min="0" step="1" placeholder="Radius">
      </mat-form-field>
    </div>
  `,
  styles: []
})
export class BorderComponent {
  @Input()
  border: IBorder;

  constructor() {}

  isEven(): boolean {
    return Object.keys(this.border).length % 2 === 0;
  }

  hasOwnProperty(property: string): boolean {
    return this.border.hasOwnProperty(property);
  }
}
