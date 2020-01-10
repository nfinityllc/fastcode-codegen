import { Injectable } from '@angular/core'; 
import { Router, CanActivate, ActivatedRouteSnapshot, RouterStateSnapshot } from '@angular/router'; 
import {AuthenticationService} from './authentication.service' 
@Injectable() 
export class AuthGuard implements CanActivate { 

constructor( private router: Router, private authSrv:AuthenticationService ) {} 

canActivate( route: ActivatedRouteSnapshot, state: RouterStateSnapshot ) { 

if ( this.authSrv.token ) { 

return true; 
} 

if(this.authSrv.loginType == 'oidc') { 
this.authSrv.AuthLogin(); 

} 
else { 
this.router.navigate( ['/login'], { queryParams: { returnUrl: state.url } } ); 
} 
return false; 
} 
} 