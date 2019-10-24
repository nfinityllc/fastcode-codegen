import { Component, Input } from '@angular/core';
import { IPadding } from '../interfaces';

@Component({
  selector: 'ip-padding',
  template: `
    <div class="group four">
      <mat-form-field appearance="outline">
        <mat-label>Top</mat-label>
        <input matInput placeholder="Size" type="number" min="0" step="1" [(ngModel)]="padding.top" />
      </mat-form-field>
      <mat-form-field appearance="outline">
        <mat-label>Right</mat-label>
        <input matInput placeholder="Size" type="number" min="0" step="1" [(ngModel)]="padding.right" />
      </mat-form-field>
      <mat-form-field appearance="outline">
        <mat-label>Bottom</mat-label>
        <input matInput placeholder="Size" type="number" min="0" step="1" [(ngModel)]="padding.bottom" />
      </mat-form-field>
      <mat-form-field appearance="outline">
        <mat-label>Left</mat-label>
        <input matInput placeholder="Size" type="number" min="0" step="1" [(ngModel)]="padding.left" />
      </mat-form-field>
    </div>
  `,
  styles: []
})
export class PaddingComponent {
  @Input()
  padding: IPadding;
}
