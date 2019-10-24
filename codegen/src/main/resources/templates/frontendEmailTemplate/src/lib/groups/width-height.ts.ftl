import { Component, OnInit, Input } from '@angular/core';
import { IWidthHeight } from '../interfaces';

@Component({
  selector: 'ip-width-height',
  template: `
    <div class="group" [ngClass]="{'three': showAutoSlider()}">
      <mat-slide-toggle *ngIf="showAutoSlider()" [checked]="model.auto" (change)="toggleChange($event)">Auto</mat-slide-toggle>
      <mat-form-field appearance="outline">
        <mat-label>{{label}}</mat-label>
        <input matInput [(ngModel)]="model.value" [disabled]="disableValueField()" type="number" [placeholder]="label">
      </mat-form-field>
      <mat-form-field appearance="outline">
        <mat-label>Unit</mat-label>
        <mat-select placeholder="Unit" [disabled]="model.auto" [(value)]="model.unit" disableRipple>
          <mat-option *ngFor="let unit of getUnits()" [value]="unit">
            {{getUnitLabel(unit)}}
          </mat-option>
        </mat-select>
      </mat-form-field>
    </div>
  `,
  styles: []
})
export class WidthHeightComponent implements OnInit {
  @Input()
  model: IWidthHeight;
  @Input()
  label: string;

  private units: Map<string, string> = new Map([
    ['%', 'Percents'],
    ['px', 'Pixels'],
    ['contain', 'Contain'],
    ['cover', 'Cover']
  ]);

  constructor() {}

  toggleChange({ checked }) {
    this.model.auto = checked;
  }

  getUnits() {
    return this.model.units || ['%', 'px'];
  }

  disableValueField() {
    return this.model.auto || ['%', 'px'].indexOf(this.model.unit) === -1;
  }

  showAutoSlider() {
    return this.model.hasOwnProperty('auto');
  }

  getUnitLabel(unit: string): string {
    return this.units.get(unit);
  }

  ngOnInit() {}
}
