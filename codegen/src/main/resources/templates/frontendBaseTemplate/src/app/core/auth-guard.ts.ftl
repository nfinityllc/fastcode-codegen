import { Injectable } from '@angular/core';
import { Router, CanActivate, ActivatedRouteSnapshot, RouterStateSnapshot } from '@angular/router';
import {AuthenticationService} from './authentication.service'
@Injectable()
export class AuthGuard implements CanActivate {
  
  constructor( private router: Router, private authSrv:AuthenticationService ) {}

  canActivate( route: ActivatedRouteSnapshot, state: RouterStateSnapshot ) {

  	if ( localStorage.getItem( 'token' ) ) {
      // Logged in so return true
      //localStorage.removeItem('token');
      
  		return true;
  	}
 /*   this.authSrv.postLogin({"userName": "employee1","password": "secret" }).subscribe(log=> {
        let l = log;
        return true;
      },error => {
        return false;
      });  	*/
    if(this.authSrv.loginType == 'oidc') {
      this.authSrv.AuthLogin({"userName": "employee1","password": "secret" }).subscribe(log=> {
        let l = log;
        return true;
      },error => {
        return false;
      });
    }
    else {
    this.router.navigate( ['/login'], { queryParams: { returnUrl: state.url } } );
    }
  	return false;
  }
}