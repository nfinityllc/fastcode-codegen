import { Component, OnInit } from '@angular/core';

import { ActivatedRoute,Router} from "@angular/router";
import { FormBuilder, FormGroup, Validators} from '@angular/forms';
import { first } from 'rxjs/operators';
import { Globals } from '../globals';
import { MatDialogRef } from '@angular/material/dialog';
 
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
       
        ) { }
 
    ngOnInit() {
       
    }
  	
	onBack(): void {
		// this.router.navigate(['/']);
	}
}
