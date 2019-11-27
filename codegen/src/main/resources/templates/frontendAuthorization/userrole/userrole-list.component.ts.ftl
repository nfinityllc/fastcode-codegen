import { Component, OnInit, ChangeDetectorRef } from '@angular/core';
import {MatDialog, MatDialogRef, MAT_DIALOG_DATA} from '@angular/material';

import { I[=AuthenticationTable]role } from './i[=moduleName]role';
import { [=AuthenticationTable]roleService } from './[=moduleName]role.service';
import { Router, ActivatedRoute } from '@angular/router';
import { [=AuthenticationTable]roleNewComponent} from './[=moduleName]role-new.component';
import { BaseListComponent, Globals, IListColumn, listColumnType, PickerDialogService, ErrorService } from 'fastCodeCore';
import { GlobalPermissionService } from '../core/global-permission.service';

import { [=AuthenticationTable]Service } from '../[=moduleName]/[=moduleName].service';
import { RoleService } from '../role/role.service';

@Component({
  selector: 'app-[=moduleName]role-list',
  templateUrl: './[=moduleName]role-list.component.html',
  styleUrls: ['./[=moduleName]role-list.component.scss']
})
export class [=AuthenticationTable]roleListComponent extends BaseListComponent<I[=AuthenticationTable]role> implements OnInit {

  title:string = "[=AuthenticationTable]role";
  
  constructor(
    public router: Router,
    public route: ActivatedRoute,
    public global: Globals,
    public dialog: MatDialog,
    public changeDetectorRefs: ChangeDetectorRef,
    public pickerDialogService: PickerDialogService,
    public dataService: [=AuthenticationTable]roleService,
    public errorService: ErrorService,
    public [=AuthenticationTable?uncap_first]Service: [=AuthenticationTable]Service,
    public roleService: RoleService,
    public globalPermissionService: GlobalPermissionService,
  ) { 
    super(router, route, dialog, global, changeDetectorRefs, pickerDialogService, dataService, errorService)
  }

  ngOnInit() {
    this.entityName = "Userrole";
    this.setAssociation();
    this.setColumns();
    <#if !UserInput??>
    this.primaryKeys = [ "roleId", "userId" ]
    <#else>
    this.primaryKeys = [ "roleId", <#list PrimaryKeys as key,value>"[=AuthenticationTable?uncap_first + key?cap_first]", </#list>]
    </#if>
    super.ngOnInit();
  }
  
  setAssociation(){
    
    this.associations = [
      {
        column: [
          <#if !UserInput??>
          {
            key: 'userId',
            value: undefined,
            referencedkey: 'id'
          },
          <#elseif UserInput??>
          <#if PrimaryKeys??>
          <#list PrimaryKeys as key,value>
          <#if value?lower_case == "long" || value?lower_case == "integer" || value?lower_case == "short" || value?lower_case == "double" || value?lower_case == "boolean" || value?lower_case == "date" || value?lower_case == "string">
          {
            key: '[=AuthenticationTable?uncap_first + key?cap_first]',
            value: undefined,
            referencedkey: '[=key]'
          },
          </#if>
          </#list>
          </#if>
          </#if>          
        ],
        isParent: false,
        <#if UserInput??>
        <#if DescriptiveField?? && DescriptiveField[AuthenticationTable]??>
        descriptiveField: '[=AuthenticationTable?uncap_first + DescriptiveField[AuthenticationTable].fieldName?cap_first]',
        referencedDescriptiveField: '[=DescriptiveField[AuthenticationTable].fieldName]',
        <#else>
        <#if AuthenticationFields??>
        <#list AuthenticationFields as authKey,authValue>
        <#if authKey== "UserName">
        descriptiveField: '[=AuthenticationTable?uncap_first]DescriptiveField',
        referencedDescriptiveField: '[=authValue.fieldName]',
        </#if>
        </#list>
        </#if>
        </#if>
        <#elseif !UserInput??>
        descriptiveField: '[=AuthenticationTable?uncap_first]DescriptiveField',
        referencedDescriptiveField: 'userName',
        </#if>
        service: this.[=AuthenticationTable?uncap_first]Service,
        associatedObj: undefined,
        table: '[=AuthenticationTable?uncap_first]',
        type: 'ManyToOne'
      },
      {
        column: [
                  {
            key: 'roleId',
            value: undefined,
            referencedkey: 'id'
          },  
        ],
        isParent: false,
        descriptiveField: 'roleDescriptiveField',
        referencedDescriptiveField: 'name',
        service: this.roleService,
        associatedObj: undefined,
        table: 'role',
        type: 'ManyToOne'
      },
    ];
  }
  
    setColumns(){
      this.columns = [
      {
          column: '[=AuthenticationTable]',
        label: '[=AuthenticationTable]',
        sort: false,
        filter: false,
        type: listColumnType.Boolean
        },
      {
          column: 'Role',
        label: 'Role',
        sort: false,
        filter: false,
        type: listColumnType.Boolean
        },
        {
        column: 'actions',
        label: 'Actions',
        sort: false,
        filter: false,
        type: listColumnType.String
      }
    ];
    this.selectedColumns = this.columns;
    this.displayedColumns = this.columns.map((obj) => { return obj.column });
    }
  
  addNew() {
    super.addNew([=AuthenticationTable]roleNewComponent);
  }
  
}
