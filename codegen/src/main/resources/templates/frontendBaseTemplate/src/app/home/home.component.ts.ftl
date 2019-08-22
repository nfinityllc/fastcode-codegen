import { Component, OnInit } from '@angular/core';

import { ActivatedRoute,Router} from "@angular/router";
import { FormBuilder, FormGroup, Validators} from '@angular/forms';
import { first } from 'rxjs/operators';
import { Globals } from '../globals';
import { MatDialogRef } from '@angular/material/dialog';
<#if AuthenticationType != "none">
import { AuthenticationService } from '../core/authentication.service';
</#if>
 
@Component({ 
  selector: 'app-home',
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.scss']
})
export class HomeComponent implements OnInit {
    itemForm: FormGroup;
    errorMessage = '';
   // iLogin: ILogin = {} as ILogin;
    loading = false;
    submitted = false;
    returnUrl: string;
    constructor(
    	private formBuilder: FormBuilder,
    	private route: ActivatedRoute,
    	public router: Router,
		private global:Globals,
		<#if AuthenticationType != "none">
		public Auth: AuthenticationService,
		</#if>
       
        ) { }
 
    ngOnInit() {
       
     /*   this.itemForm = this.formBuilder.group({
       
         userName: ['', Validators.required],
         password: ['', Validators.required]       
           
        });
       this.authenticationService.logout();
       this.returnUrl = this.route.snapshot.queryParams['returnUrl'] || '/';
       */
    }
   
   <#if AuthenticationType != "none">
    onSubmit() {
       // this.submitted = true;
       
        
        if(this.Auth.loginType == 'oidc')
        { 
          //this.router.navigate([this.Auth.authUrl]);
        //  window.location.href = this.Auth.authUrl;
        this.router.navigate(['/dashboard']);
        }
        else {
          this.router.navigate(['/login'],{ queryParams: { returnUrl: 'dashboard' } });
        }
        
    }
    </#if>
    onBack(): void {
       // this.router.navigate(['/']);
      }
    
}
