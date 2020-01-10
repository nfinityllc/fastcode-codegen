import { Component, OnInit } from '@angular/core';

import { ActivatedRoute,Router} from "@angular/router";
import { FormBuilder, FormGroup, Validators} from '@angular/forms';
import { first } from 'rxjs/operators';
import { Globals } from '../globals';
import { MatDialogRef } from '@angular/material/dialog';
<#if AuthenticationType != "none">
import { AuthenticationService } from '../core/authentication.service';
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
		public authService: AuthenticationService,
		private oauthService: OAuthService,
		</#if>
       
        ) { }
 
    ngOnInit() {
       
    }
  	
   <#if AuthenticationType != "none">
   logout() {
		this.oauthService.logOut();
  	}
   
	onSubmit() {
		if(this.authService.loginType == 'oidc') {
			this.logout();
			this.oauthService.initLoginFlow();
		}
		else{
			this.router.navigate(['/login'],{ queryParams: { returnUrl: 'dashboard' } });
		}
	}
	</#if>
	onBack(): void {
		// this.router.navigate(['/']);
	}
}
