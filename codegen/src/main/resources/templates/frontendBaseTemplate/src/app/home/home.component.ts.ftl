import { Component, OnInit } from '@angular/core';

import { ActivatedRoute,Router} from "@angular/router";
import { FormBuilder, FormGroup, Validators} from '@angular/forms';
import { first } from 'rxjs/operators';
import { Globals } from '../globals';
import { MatDialogRef } from '@angular/material/dialog';
<#if AuthenticationType != "none">
import { AuthenticationService } from '../core/authentication.service';
</#if>
<#if AuthenticationType == 'oidc'>
import { OAuthService } from 'angular-oauth2-oidc';
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
		<#if AuthenticationType == 'oidc'>
		private oauthService: OAuthService,
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
	<#if AuthenticationType == 'oidc'>
	logout() {
		this.oauthService.logOut();
  	}
	</#if>
   <#if AuthenticationType != "none">
	onSubmit() {
        <#if AuthenticationType == 'oidc'>
		this.logout();
		this.oauthService.initLoginFlow();
  		<#else>          
		this.router.navigate(['/login'],{ queryParams: { returnUrl: 'dashboard' } });
        </#if>
        
    }
    </#if>
    onBack(): void {
       // this.router.navigate(['/']);
    }
    
}
