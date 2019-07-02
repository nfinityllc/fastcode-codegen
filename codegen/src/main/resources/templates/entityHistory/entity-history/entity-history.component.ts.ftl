import { Component, OnInit, ChangeDetectorRef } from '@angular/core';
import { EntityHistory, IEntityHistory } from './entityHistory';
import { EntityHistoryService } from './entity-history.service';
import { MatTableDataSource, Sort, MatDialog, MatDialogRef, MAT_DIALOG_DATA } from "@angular/material";
import { Globals } from '../globals';
import { ManageEntityHistoryComponent } from '../manage-entity-history/manage-entity-history.component';


@Component({
  selector: 'app-entity-history',
  templateUrl: './entity-history.component.html',
  styleUrls: ['./entity-history.component.scss']
})

export class EntityHistoryComponent implements OnInit {
  entityHistory: IEntityHistory[] = [];
  errorMessage: '';
  displayedColumns: string[] = ['entity', 'cdoId', 'changeType', 'author', 'commitDate', 'propertyName', 'previousValue', 'currentValue']

  public dataSource;
  sortedData: IEntityHistory[];

  isMediumDeviceOrLess: boolean;
  dialogRef: MatDialogRef<any>;
  mediumDeviceOrLessDialogSize: string = "100%";
  largerDeviceDialogWidthSize: string = "75%";
  largerDeviceDialogHeightSize: string = "75%";

  filterFields = [];

  constructor(private global: Globals,
    private entityHistoryService: EntityHistoryService, private changeDetectorRefs: ChangeDetectorRef,
    public dialog: MatDialog, ) { }

  ngOnInit() {
    this.manageScreenResizing();
    this.getEntityHistory();
  }

  getEntityHistory(){
    this.entityHistoryService.getAll().subscribe(
      perms => {
        this.entityHistory = perms;
        this.dataSource = new MatTableDataSource(this.entityHistory);
        this.sortedData = this.entityHistory.slice();
      },
      error => this.errorMessage = <any>error
    );
  }

  manageScreenResizing(){
    this.global.isMediumDeviceOrLess$.subscribe(value => {
      this.isMediumDeviceOrLess = value;
      if (value)
        this.displayedColumns = ['entity', 'cdoId', 'commitDate', 'author'];
      else
        this.displayedColumns = ['entity', 'cdoId', 'changeType', 'author', 'commitDate', 'propertyName', 'previousValue', 'currentValue']

      if (this.dialogRef)
        this.dialogRef.updateSize(value ? this.mediumDeviceOrLessDialogSize : this.largerDeviceDialogWidthSize,
          value ? this.mediumDeviceOrLessDialogSize : this.largerDeviceDialogHeightSize);
    });
  }

  applyFilter() {

  }

  // sorting
  sortData(sort: Sort) {
    const data = this.dataSource.filteredData.slice();
    if (!sort.active || sort.direction === '') {
      this.sortedData = data;
      return;
    }

    this.sortedData = data.sort((a, b) => {
      a = a;
      b = b;
      const isAsc = sort.direction === 'asc';
      switch (sort.active) {
        case 'entity': return compare(a.globalId.entity, b.globalId.entity, isAsc);
        case 'cdoId': return compare(a.globalId.cdoId, b.globalId.cdoId, isAsc);
        case 'author': return compare(a.commitMetadata.author, b.commitMetadata.author, isAsc);
        case 'commitDate': return compare(a.commitMetadata.commitDate, b.commitMetadata.commitDate, isAsc);
        case 'changeType': return compare(a.changeType, b.changeType, isAsc);
        default: return 0;
      }
    });

    this.dataSource.data = this.sortedData;
    this.changeDetectorRefs.detectChanges();

  }

  openDialog() {

    this.dialogRef = this.dialog.open(ManageEntityHistoryComponent, {
      disableClose: true,
      height: this.isMediumDeviceOrLess ? this.mediumDeviceOrLessDialogSize : this.largerDeviceDialogHeightSize,
      width: this.isMediumDeviceOrLess ? this.mediumDeviceOrLessDialogSize : this.largerDeviceDialogWidthSize,
      maxWidth: "none",
      panelClass: 'fc-modal-dialog'
    });
    this.dialogRef.afterClosed().subscribe(result => {
      console.log(`Dialog result: ${result}`);

    });

  }

  add() {
    //this.openDialog();
  }
  closeUserDialog() {
    var result: any;
    this.dialogRef.close(result);
  }

}
function compare(a, b, isAsc) {
  return (a < b ? -1 : 1) * (isAsc ? 1 : -1);
}

