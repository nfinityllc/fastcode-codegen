import { Component, OnInit } from '@angular/core';
//import { LoginService } from './login.service';
//import { ILogin } from './ilogin';
import { ActivatedRoute,Router} from "@angular/router";
import { FormBuilder, FormGroup, Validators, ValidationErrors, AbstractControl, ValidatorFn} from '@angular/forms';
import { first } from 'rxjs/operators';
import { Globals } from '../globals';
import { MatDialogRef } from '@angular/material/dialog';
import { AuthenticationService } from '../core/authentication.service';
 
@Component({  
  template: ''
})
export class CallbackComponent implements OnInit {
    itemForm: FormGroup;
    errorMessage = '';
   // iLogin: ILogin = {} as ILogin;
    loading = false;
    submitted = false;
    returnUrl: string='dashboard';
    constructor(private formBuilder: FormBuilder,private route: ActivatedRoute, private router: Router,
       private global:Globals, private authenticationService: AuthenticationService,
       
        ) { }
 
    ngOnInit() {
        if(this.route.snapshot.queryParams)
        {    
            console.log("login query parameter");
            this.returnUrl = this.route.snapshot.queryParams['returnUrl'] || 'dashboard';
            let code =  this.route.snapshot.queryParams['code'] ;
            
            if(!code)
              this.router.navigate(['dashboard']);
       }
       else {
        this.router.navigate(['dashboard']);
       }
     
        
      
       
    }
   
    // convenience getter for easy access to form fields
   
    
   
    onBack(): void {
        this.router.navigate(['/']);
      }
    
}
