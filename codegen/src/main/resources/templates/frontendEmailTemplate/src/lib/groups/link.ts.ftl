import { Component, Input } from '@angular/core';
import { ILink, TLinkTarget } from '../interfaces';

@Component({
  selector: 'ip-link',
  template: `
    <div class="group f-large">
      <mat-form-field appearance="outline">
        <mat-label>Link</mat-label>
        <input matInput [(ngModel)]="link.href" type="url" placeholder="Link">
      </mat-form-field>
      <mat-form-field appearance="outline">
        <mat-label>Target</mat-label>
        <mat-select placeholder="Target" [(value)]="link.target" disableRipple>
          <mat-option *ngFor="let target of getTargets()" [value]="target">
            {{getTargetLabel(target)}}
          </mat-option>
        </mat-select>
      </mat-form-field>
    </div>
  `
})
export class LinkComponent {
  @Input()
  link: ILink;

  private targetLabels = new Map([
    ['_blank', 'Blank'],
    ['_self', 'Self'],
    ['_parent', 'Parent'],
    ['_top', 'Top']
  ]);

  getTargets(): TLinkTarget[] {
    return ['_blank', '_self', '_parent', '_top'];
  }

  getTargetLabel(target) {
    return this.targetLabels.get(target);
  }
}
