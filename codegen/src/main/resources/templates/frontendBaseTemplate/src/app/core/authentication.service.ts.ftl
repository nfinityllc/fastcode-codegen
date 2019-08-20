import { Injectable } from '@angular/core';
import { HttpClient,HttpHeaders, HttpErrorResponse } from '@angular/common/http';
import { Observable, of,throwError, observable } from 'rxjs';
import { catchError, tap, map,filter } from 'rxjs/operators';
import { environment } from 'src/environments/environment';
import { IPermissions } from '../permissions';
//import { IUser } from '../users/iuser';
import { JwtHelperService } from "@auth0/angular-jwt";
//import {ITokenDetail} from "./itoken-detail";
import { IGlobalPermissionService,ITokenDetail } from 'projects/fast-code-core/src/public_api';
const API_URL = environment.apiUrl;
const helper = new JwtHelperService();
@Injectable()
export class AuthenticationService  {
  private _reqOptionsArgs= { headers: new HttpHeaders().set( 'Content-Type', 'application/json' ).append('Access-Control-Allow-Origin', '*') };

  private apiUrl = API_URL;// 'http://localhost:5555';
  public loginType = environment.loginType;
  public authUrl = environment.authUrl;
  private userPermissions:IPermissions[];
  private decodedToken:ITokenDetail;
  constructor(private http: HttpClient ) { 
  }
  getMainUsers(): Observable<any> {    
   return this.http.get<any[]>(this.apiUrl + '/users' ).pipe( catchError(this.handleError));
   
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
  postLogin(user: any): Observable<any> {
      console.log("AFSD")
      return this.http.post<any>(this.apiUrl+'/login', user, this._reqOptionsArgs).pipe(map(res => {
          let retval = res;
          console.log(retval)
          localStorage.setItem("salt", retval.salt);  
          localStorage.setItem("token", retval.token);
          this.decodedToken = null; 
          this.decodeToken();
          return retval;
      }));      
  //    return this.http.post<any>(this.apiUrl +'/login', user, this._reqOptionsArgs).pipe(catchError(this.handleError));
  }
  AuthLogin(user: any): Observable<any> {
    console.log("AFSD")
    return this.http.get<any>(this.authUrl+'/oidc',this._reqOptionsArgs).pipe(map(res => {
        let retval = res;
        console.log(retval)
        localStorage.setItem("salt", retval.salt);  
        localStorage.setItem("token", retval.token);
        return retval;
    }),catchError(error=> {
        let err = error;
        return error;
    }));      
//    return this.http.post<any>(this.apiUrl +'/login', user, this._reqOptionsArgs).pipe(catchError(this.handleError));
}
  logout() {
   
    localStorage.removeItem('token');
}
  
getTokenExpirationDate(token: string): Date {
  const decoded = helper.decodeToken(token);

  if (decoded.exp === undefined) return null;

  const date = new Date(0); 
  date.setUTCSeconds(decoded.exp);
  return date;
}

isTokenExpired(token?: string): boolean {
  if(!token) token = this.token;
  if(!token) return true;

  const date = this.getTokenExpirationDate(token);
  if(date === undefined) return false;
  return !(date.valueOf() > new Date().valueOf());
}
public createTokenHeader(): HttpHeaders {
    let reqOptions = new HttpHeaders().set( 'Content-Type', 'application/json' ).append('Access-Control-Allow-Origin', '*');
    if(this.token) {
        reqOptions = new HttpHeaders().set( 'Content-Type', 'application/json' ).set('Authorization', 'Bearer ' + this.token);
    }
    return reqOptions;
}
private handleError(err: HttpErrorResponse) {
  
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
  /** Log a HeroService message with the MessageService */
  private log(message: string) {
   console.log(message);
  }

  getUserPermissions(): Observable<any> {    
    
    if(this.userPermissions) 
        return of( this.userPermissions);
    else {
     /*  this.http.get<IPermissions[]>(this.apiUrl + '/users/1/permissions' ).subscribe(permissions=> {
        this.userPermissions= permissions;
        return of( this.userPermissions);
      })*/
    return this.http.get<IPermissions[]>(this.apiUrl + '/users/1/permissions' ).pipe(map(permissions => {
        let x = permissions;
        this.userPermissions = permissions;
       
        return of(this.userPermissions);
     }) ); 
    }
     
  }
  hasPermissionOnEntity(entity:string, crudType:string):Boolean {
   // this.userPermissions.filter(perm => perm.name.match('/'+ entity + '/i') && perm.name.match('/'+ crudType + '/i') );
      /*return   this.userPermissions.(map(perms=> {
          let pms =  perms.filter(perm => perm.name.match('/'+ entity + '/i') && perm.name.match('/'+ crudType + '/i') );
          return (pms !=null && pms.length > 0) ? true: false;
          }
          ));*/
       let filtered=   this.userPermissions.filter(perm => {
        var entityRg = new RegExp(entity , 'i');
        var crudRg = new RegExp(crudType , 'i');
       return  perm.name.match(entityRg) && perm.name.match(crudRg) ;
        } );
       return filtered ? filtered.length > 0: false;

  }
}