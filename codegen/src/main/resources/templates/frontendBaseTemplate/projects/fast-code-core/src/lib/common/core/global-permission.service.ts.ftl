import { Injectable } from '@angular/core';
import { HttpClient,HttpHeaders, HttpErrorResponse } from '@angular/common/http';
import { Observable, of,throwError, observable } from 'rxjs';
import { catchError, tap, map,filter } from 'rxjs/operators';

//import { IUser } from '../users/iuser';
//import { IGlobalPermissionService,ITokenDetail } from 'projects/fast-code-core/src/public_api';
//import { AuthenticationService } from './authentication.service';

//import { ITokenDetail } from './itoken-detail';
import { JwtHelperService } from "@auth0/angular-jwt";
import { IGlobalPermissionService } from './iglobal-permission.service';
import { ITokenDetail } from './itoken-detail';
const helper = new JwtHelperService();


@Injectable()
export class GlobalPermissionService implements IGlobalPermissionService {
  private _reqOptionsArgs= { headers: new HttpHeaders().set( 'Content-Type', 'application/json' ).append('Access-Control-Allow-Origin', '*') };

  
  //private userPermissions:IPermission[];
  private decodedToken:ITokenDetail;
  constructor(private http: HttpClient ) { 
  }
 
  
  get token():string {
    return !localStorage.getItem("token") ? null : localStorage.getItem("token");
}
decodeToken():ITokenDetail {
  if(this.decodedToken)
  {
    return this.decodedToken;
  }
 else {
    if(this.token)
    { 
      this.decodedToken = helper.decodeToken(this.token) as ITokenDetail;
      return this.decodedToken;
    }
    else 
    return null;
}
}
  hasPermissionOnEntity(entity:string, crudType:string):Boolean {   
    let tokenDetails:ITokenDetail = this.
    decodeToken();
    //tokenDetails.scopes = tokenDetails.scopes.filter(item=>item != "USERSENTITY_CREATE");
    let filtered=   tokenDetails.scopes.filter(perm => {
      var entityRg = new RegExp(entity , 'i');
      var crudRg = new RegExp(crudType , 'i');
     return  perm.match(entityRg) && perm.match(crudRg) ;
      } );
     return filtered ? filtered.length > 0: false;
  }
  /*checkPermission(entity:string, crudType:string):boolean {
    let filtered=   this.userPermissions.filter(perm => {
      var entityRg = new RegExp(entity , 'i');
      var crudRg = new RegExp(crudType , 'i');
     return  perm.name.match(entityRg) && perm.name.match(crudRg) ;
      } );
     return filtered ? filtered.length > 0: false;
  }*/
/*private handleError(err: HttpErrorResponse) {
  
    let errorMessage = '';
    if (err.error instanceof ErrorEvent) {
      // A client-side or network error occurred. Handle it accordingly.
      errorMessage = `An error occurred: ${err.error.message}`;
    } else {
      
      errorMessage = `Server returned code: ${err.status}, error message is: ${err.message}`;
    }
    console.error(errorMessage);
    return throwError(errorMessage);
  }
  
 */

}