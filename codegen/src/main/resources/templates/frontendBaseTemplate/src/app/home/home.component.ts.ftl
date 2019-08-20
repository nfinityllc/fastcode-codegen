import { Component, OnInit } from '@angular/core';

import { ActivatedRoute,Router} from "@angular/router";
import { FormBuilder, FormGroup, Validators} from '@angular/forms';
import { first } from 'rxjs/operators';
import { Globals } from '../globals';
import { MatDialogRef } from '@angular/material/dialog';
import { AuthenticationService } from '../core/authentication.service';
 
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
    constructor(private formBuilder: FormBuilder,private route: ActivatedRoute, public router: Router,
       private global:Globals, public Auth: AuthenticationService,
       
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
   
    // convenience getter for easy access to form fields
    get f() { return this.itemForm.controls; }
 
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
    onBack(): void {
       // this.router.navigate(['/']);
      }
    
}
