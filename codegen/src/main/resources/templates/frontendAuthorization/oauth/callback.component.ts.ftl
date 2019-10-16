import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from "@angular/router";
import { FormBuilder, FormGroup, Validators, ValidationErrors, AbstractControl, ValidatorFn } from '@angular/forms';
import { first } from 'rxjs/operators';
import { Globals } from 'fastCodeCore';
import { MatDialogRef } from '@angular/material/dialog';
import { AuthenticationService } from '../core/authentication.service';

@Component({
	template: ''
})
export class CallbackComponent implements OnInit {
	itemForm: FormGroup;
	errorMessage = '';
	loading = false;
	submitted = false;
	returnUrl: string = 'dashboard';
	constructor(
		private formBuilder: FormBuilder,
		private route: ActivatedRoute,
		private router: Router,
		private global: Globals,
		private authenticationService: AuthenticationService,
	) { }

	ngOnInit() {
		if (this.route.snapshot.queryParams) {
			console.log("login query parameter");
			this.returnUrl = this.route.snapshot.queryParams['returnUrl'] || 'dashboard';
			let code = this.route.snapshot.queryParams['code'];

			if (!code){
				this.router.navigate(['dashboard']);
			}
		}
		else {
			this.router.navigate(['dashboard']);
		}
	}

	onBack(): void {
		this.router.navigate(['/']);
	}

}
