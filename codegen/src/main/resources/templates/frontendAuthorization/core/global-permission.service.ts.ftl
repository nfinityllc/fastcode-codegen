import { Injectable } from '@angular/core';
import { HttpClient,HttpHeaders, HttpErrorResponse } from '@angular/common/http';
import { Observable, of,throwError, observable } from 'rxjs';
import { catchError, tap, map,filter } from 'rxjs/operators';
import { environment } from 'src/environments/environment';
import { IPermission } from '../permission';
//import { IUser } from '../users/iuser';
import { IGlobalPermissionService,ITokenDetail } from 'fastCodeCore';
import { AuthenticationService } from './authentication.service';
//import { ITokenDetail } from './itoken-detail';
const API_URL = environment.apiUrl;

@Injectable()
export class GlobalPermissionService implements IGlobalPermissionService {
  private _reqOptionsArgs= { headers: new HttpHeaders().set( 'Content-Type', 'application/json' ).append('Access-Control-Allow-Origin', '*') };

  private apiUrl = API_URL;// 'http://localhost:5555';
  public loginType = environment.loginType;
  public authUrl = environment.authUrl;
  private userPermissions:IPermission[];
  constructor(private http: HttpClient, private authService:AuthenticationService ) { 
  }
 /*
  getUserPermissions(): Observable<any> {    
    let scopes = this.authService.decodeToken();
    if(this.userPermissions) 
        return of( this.userPermissions);
    else {
    
    return this.http.get<IPermission[]>(this.apiUrl + '/users/1/permissions' ).pipe(map(permissions => {
        let x = permissions;
        this.userPermissions = permissions;
       
        return of(this.userPermissions);
     }) ); 
    }
     
  }*/
  
  hasPermissionOnEntity(entity:string, crudType:string):Boolean {   
    let tokenDetails:ITokenDetail = this.authService.decodeToken();
    //tokenDetails.scopes = tokenDetails.scopes.filter(item=>item != "USERSENTITY_CREATE");
    crudType = crudType != "READ"? crudType : crudType + "|" + "CREATE" + "|" + "UPDATE" + "|" + "DELETE"
    let filtered=   tokenDetails.scopes.filter(perm => {
      var entityRg = new RegExp(entity , 'i');
      var crudRg = new RegExp(crudType , 'i');
     return  perm.match(entityRg) && perm.match(crudRg) ;
      } );
     return filtered ? filtered.length > 0: false;
  }
  checkPermission(entity:string, crudType:string):boolean {
    let filtered=   this.userPermissions.filter(perm => {
      var entityRg = new RegExp(entity , 'i');
      var crudRg = new RegExp(crudType , 'i');
     return  perm.name.match(entityRg) && perm.name.match(crudRg) ;
      } );
     return filtered ? filtered.length > 0: false;
  }
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