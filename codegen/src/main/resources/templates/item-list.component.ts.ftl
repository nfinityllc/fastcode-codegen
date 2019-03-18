import { Component, OnInit, ChangeDetectorRef } from '@angular/core';
import {MatDialog, MatDialogRef, MAT_DIALOG_DATA} from '@angular/material';

import { ${IEntity} } from './${IEntityFile}';
import { ${ClassName}Service } from './${ModuleName}.service';
import { Router } from '@angular/router';
import {${ClassName}NewComponent} from './${ModuleName}-new.component';
import {BaseListComponent} from '../base/base-list.component';
import { Globals } from '../globals';
import { IListColumn, listColumnType } from '../common/ilistColumn';
import { IpEmailBuilderService } from 'ip-email-builder/public_api';
import { ComponentType } from '@angular/cdk/portal';
@Component({
  selector: 'app-${ModuleName}-list',
  templateUrl: './${ModuleName}-list.component.html',
  styleUrls: ['./${ModuleName}-list.component.scss']
})
export class ${ClassName}ListComponent extends BaseListComponent<${IEntity}> implements OnInit {

  title:string = "${ClassName}s";
  
  columns: IListColumn[] = [
     <#list Fields as key,value>
          <#if value.fieldType?lower_case == "string">
               {
              column: '${value.fieldName}',
              label: '${value.fieldName}',
              sort: true,
              filter: true,
              type: listColumnType.String
            },
          </#if> 
      </#list>    
  ];
  selectedColumns = this.columns;
  displayedColumns: string[] = this.columns.map((obj) => { return obj.column });

  
  constructor(public router: Router,public global:Globals, public ${InstanceName}Service: ${ClassName}Service,
    public dialog: MatDialog,public changeDetectorRefs: ChangeDetectorRef) { 
      super(router,global,${InstanceName}Service,dialog,changeDetectorRefs)
    }

  ngOnInit() {
    
    super.ngOnInit();
    
  }
  
addNew() {
  super.addNew(${ClassName}NewComponent);
}
  
}
