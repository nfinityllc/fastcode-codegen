import { Component, OnInit, Input } from '@angular/core';
import { IpEmailBuilderService } from '../ip-email-builder.service';
import { IFont, TFontStyle, IFontFamily, TFontWeight } from '../interfaces';

@Component({
  selector: 'ip-font-styles',
  template: `
    <div class="group">
      <mat-form-field appearance="outline" *ngIf="font.family">
        <mat-label>Family</mat-label>
        <mat-select placeholder="Family" [(value)]="font.family" disableRipple>
          <mat-option *ngFor="let name of getFontFamiliesNames()" [value]="name">
            {{name}}
          </mat-option>
        </mat-select>
      </mat-form-field>
      <mat-form-field appearance="outline" *ngIf="font.style">
        <mat-label>Style</mat-label>
        <mat-select placeholder="Style" [(value)]="font.style" disableRipple>
          <mat-option *ngFor="let style of getFontStyles()" [value]="style">
            {{style}}
          </mat-option>
        </mat-select>
      </mat-form-field>
    </div>

    <div class="group">
      <mat-form-field appearance="outline" *ngIf="font.weight">
        <mat-label>Weight</mat-label>
        <mat-select placeholder="Weight" [(value)]="font.weight" disableRipple>
          <mat-option *ngFor="let weight of getCurrentFontWeights()" [value]="weight">
            {{weight}}
          </mat-option>
        </mat-select>
      </mat-form-field>
      <mat-form-field appearance="outline" *ngIf="font.size">
        <mat-label>Size</mat-label>
        <input matInput placeholder="Size" type="number" max="30" min="10" step="1" [(ngModel)]="font.size" />
      </mat-form-field>
    </div>
  `,
  styles: []
})
export class FontStylesComponent {
  @Input()
  font: IFont;

  fontFamilies: IFontFamily;
  constructor(_EBS: IpEmailBuilderService) {
    this.fontFamilies = _EBS.getFonts();
  }

  getFontStyles(): TFontStyle[] {
    return ['italic', 'normal', 'oblique'];
  }

  getFontFamiliesNames(): string[] {
    return Array.from(this.fontFamilies.keys());
  }

  getCurrentFontWeights(): TFontWeight[] {
    return [
      ...this.fontFamilies
        .get(this.font.family)
        .match(/\d+/g)
        .map(Number),
      'bold',
      'bolder',
      'inherit',
      // 'initial',
      'light',
      'normal'
    ];
  }
}
