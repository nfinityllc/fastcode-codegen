import { Component, OnInit } from '@angular/core';

import { ActivatedRoute,Router} from "@angular/router";
import { FormBuilder, FormGroup, Validators} from '@angular/forms';
import { first } from 'rxjs/operators';
import { Globals } from '../globals';
import { MatDialogRef } from '@angular/material/dialog';
 
@Component({ 
  selector: 'app-dashboard',
  templateUrl: './dashboard.component.html',
  styleUrls: ['./dashboard.component.scss']
})
export class DashboardComponent implements OnInit {
    itemForm: FormGroup;
    errorMessage = '';
   // iLogin: ILogin = {} as ILogin;
    loading = false;
    submitted = false;
    returnUrl: string;
    constructor(
    	private formBuilder: FormBuilder,
    	private route: ActivatedRoute,
    	private router: Router,
		private global:Globals,
       
	) { }
 
    ngOnInit() {
       
     /*   this.itemForm = this.formBuilder.group({
       
         userName: ['', Validators.required],
         password: ['', Validators.required]       
           
        });
       this.authenticationService.logout();
       this.returnUrl = this.route.snapshot.queryParams['returnUrl'] || '/';
       */
     /* this.globalService.getUserPermissions().subscribe(permissions=> {
        let x = permissions;
        let a = this.globalService.hasPermissionOnEntity('Roles','Read');
      
      })*/
      let x =3;
    }
   
    // convenience getter for easy access to form fields
    get f() { return this.itemForm.controls; }
 
    onSubmit() {
       // this.submitted = true;
        this.router.navigate(['/user']); 
        // stop here if form is invalid
        
    }
    onBack(): void {
       // this.router.navigate(['/']);
      }
    
}
