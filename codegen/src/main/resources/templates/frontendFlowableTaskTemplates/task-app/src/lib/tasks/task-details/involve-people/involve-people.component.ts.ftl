import { Component, OnInit, Inject, ViewChild } from '@angular/core';
import { MAT_DIALOG_DATA } from '@angular/material';
import { MatDialogRef } from '@angular/material/dialog';
import { MatSelectionList, MatListOption } from '@angular/material';
import { SelectionModel } from '@angular/cdk/collections';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';

import { UserService } from '../../../common/services/user.service';
import { IInvolvePeopleDialogConfig } from './involve-people-dialog-config';

@Component({
  selector: 'app-involve-people',
  templateUrl: './involve-people.component.html',
  styleUrls: ['./involve-people.component.scss']
})
export class InvolvePeopleComponent implements OnInit {
  users: any[] = [];
  @ViewChild(MatSelectionList, { read: true, static: true }) selectionList: MatSelectionList;

  hasNextPage: boolean;

  userForm: FormGroup;
  loading = false;
  submitted = false;

  constructor(private userService: UserService, @Inject(MAT_DIALOG_DATA) public data: IInvolvePeopleDialogConfig,
    public dialogRef: MatDialogRef<InvolvePeopleComponent>, private formBuilder: FormBuilder) { }

  ngOnInit() {
    this.selectionList.selectedOptions = new SelectionModel<MatListOption>(false);

    this.userForm = this.formBuilder.group({
      name: ['']
    });

    this.getUsers();
  }

  getUsers() {
    this.userService.getFilteredUsers("", this.data.excludeTaskId, this.data.excludeProcessId, this.data.tenantId, this.data.group).subscribe((response) => {
      console.log(response)
      if (response.start === 0) {
        if (this.data.excludePeopleIds && this.data.excludePeopleIds.length > 0)
          this.users = response.data.filter(
            user => this.data.excludePeopleIds.indexOf(user.id) == -1);
        else
          this.users = response.data;
      }
      else {
        if (this.data.excludePeopleIds && this.data.excludePeopleIds.length > 0)
          this.users = this.users.concat(response.data.filter(
            user => this.data.excludePeopleIds.indexOf(user.id) == -1));
        else
          this.users = this.users.concat(response.data);
      }
      this.hasNextPage = (response.start + response.size < response.total);
    })
  }

  onCancel(): void {
    this.dialogRef.close(null);
  }

  onSelect() {
    let selectedOption = null;
    if (this.selectionList.selectedOptions.selected.length > 0)
      selectedOption = this.selectionList.selectedOptions.selected[0].value;
    this.dialogRef.close(selectedOption);
  }

  onSearch() {
    this.userService.getFilteredUsers(this.userForm.get('name').value, this.data.excludeTaskId, this.data.excludeProcessId, this.data.tenantId, this.data.group).subscribe((response) => {

      if (response.start === 0) {
        this.users = response.data;
      }
      else {
        this.users = this.users.concat(response.data);
      }
      this.hasNextPage = (response.start + response.size < response.total);
    })
  }

  submit($event) {
    $event.preventDefault();
    this.onSearch();
  }

}
