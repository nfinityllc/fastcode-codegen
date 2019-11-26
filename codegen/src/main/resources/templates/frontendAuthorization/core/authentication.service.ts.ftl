import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders, HttpErrorResponse } from '@angular/common/http';
import { Observable, of, throwError, observable } from 'rxjs';
import { catchError, tap, map, filter } from 'rxjs/operators';
import { environment } from 'src/environments/environment';
import { IPermission } from '../permission';
//import { IUser } from '../users/iuser';
import { JwtHelperService } from "@auth0/angular-jwt";
//import {ITokenDetail} from "./itoken-detail";
import { IGlobalPermissionService, ITokenDetail } from 'fastCodeCore';
//import {AuthOidcConfig} from './oauth/auth-oidc-config'
const API_URL = environment.apiUrl;
const helper = new JwtHelperService();
import { AuthOidcConfig } from '../oauth/auth-oidc-config';
import { OAuthService, JwksValidationHandler, OAuthStorage, OAuthErrorEvent, OAuthSuccessEvent, OAuthInfoEvent } from 'angular-oauth2-oidc';
import { Router } from '@angular/router';
<#if FlowableModule!false>
import { CookieService } from './cookie.service';
</#if>

@Injectable()
export class AuthenticationService {
  private _reqOptionsArgs = {
    withCredentials: true,
    headers: new HttpHeaders().set('Content-Type', 'application/json').append('Access-Control-Allow-Origin', '*')
  };
  <#if FlowableModule!false>
  private cookieName = 'FLOWABLE_REMEMBER_ME';
  private cookieValue = '';
  </#if>
  private apiUrl = API_URL;// 'http://localhost:5555';
  public loginType = environment.loginType;
  public authUrl = environment.authUrl;
  private userPermissions: IPermission[];
  private oidcPermissions: string[] = [];
  private decodedToken: ITokenDetail;
  constructor(
    private http: HttpClient,
    private router: Router,
    private oauthService: OAuthService,
    private authStorage: OAuthStorage,
    <#if FlowableModule!false>
    private cookieService: CookieService,
    </#if>
  ) {
  }

  configure() {

    this.oauthService.configure(AuthOidcConfig);
    this.oauthService.tokenValidationHandler = new JwksValidationHandler();

    this.oauthService.events.subscribe(event => {
      if (event instanceof OAuthErrorEvent) {
        console.error(event);
      }
      else if (event instanceof OAuthSuccessEvent) {

        console.log('Oauth success:' + event.type);
        if (event.type == "token_received") {
          this.getLoggedInUserPermissions().subscribe(permsList => {
            this.oidcPermissions = permsList;
            this.router.navigate(['dashboard']);
          })

        }

      }
      else if (event instanceof OAuthInfoEvent) {
        console.log(event);
      }
      else {
        console.warn(event);
      }
    });
    this.oauthService.loadDiscoveryDocumentAndTryLogin().then(r => {
      console.log("logged in!");
    }).catch(err => {
      console.log("Unable to login");
    }); //with login form
    //this.oauthService.loadDiscoveryDocumentAndLogin()
  }

  getMainUsers(): Observable<any> {
    return this.http.get<any[]>(this.apiUrl + '/users').pipe(catchError(this.handleError));
  }

  get token(): string {
    if (environment.loginType == 'oidc') {
      return this.authStorage.getItem('access_token')
    }
    else {
      return !localStorage.getItem("token") ? null : localStorage.getItem("token");
    }
  }
  decodeToken(): ITokenDetail {
    if (this.decodedToken) {
      if (this.loginType == 'oidc' && this.decodedToken.scopes.length == 0) {
        this.decodedToken.scopes = this.oidcPermissions || [];
      }
      return this.decodedToken;
    }
    else {
      if (this.token) {
        let decodedToken: ITokenDetail = helper.decodeToken(this.token) as ITokenDetail;
        if (this.loginType == 'oidc') {
          decodedToken.scopes = this.oidcPermissions || [];
        }
        this.decodedToken = decodedToken;
        return this.decodedToken;
      }
      else
        return null;
    }
  }
  postLogin(user: any): Observable<any> {
    console.log("AFSD")
    return this.http.post<any>(this.apiUrl + '/login', user, this._reqOptionsArgs).pipe(map(res => {
      let retval = res;
      console.log(retval)
      localStorage.setItem("salt", retval.salt);
      localStorage.setItem("token", retval.token);
      <#if FlowableModule!false>
      this.cookieValue = retval.FLOWABLE_REMEMBER_ME;
      this.cookieService.set(this.cookieName, this.cookieValue);
      this.cookieService.set(this.cookieName, this.cookieValue, null, null, environment.flowableUrl);
      </#if>
      this.decodedToken = null;
      this.decodeToken();
      return retval;
    }));
    //    return this.http.post<any>(this.apiUrl +'/login', user, this._reqOptionsArgs).pipe(catchError(this.handleError));
  }

  getLoggedInUserPermissions(): Observable<any> {
    console.log("AFSD")
    return this.http.get<any>(this.authUrl + '/user/me', this._reqOptionsArgs).pipe(map(res => {
      let retval = res;

      return retval;
    }), catchError((error, caught) => {
      let err = error;
      let c = caught;
      return error;
    }));

  }

  AuthLogin() {
    console.log("AuthLogin start ...")
    this.oauthService.initLoginFlow();
  }

  logout() {
     if(environment.loginType == "oidc")
    {
     localStorage.removeItem('token');
        this.oauthService.logOut();
    }
    else if( localStorage.getItem('token')) {      
     this.http.post<any>(this.apiUrl+'/auth/logout', null, this._reqOptionsArgs).subscribe(result => {
     
       this.oauthService.logOut();
     })
     localStorage.removeItem('token');
     <#if FlowableModule!false>
     this.cookieService.set(this.cookieName, 'UNKNOWN');
     </#if>
   }
  
   }

  getTokenExpirationDate(token: string): Date {
    const decoded = helper.decodeToken(token);

    if (decoded.exp === undefined) return null;

    const date = new Date(0);
    date.setUTCSeconds(decoded.exp);
    return date;
  }

  isTokenExpired(token?: string): boolean {
    if (!token) token = this.token;
    if (!token) return true;

    const date = this.getTokenExpirationDate(token);
    if (date === undefined) return false;
    return !(date.valueOf() > new Date().valueOf());
  }
  public createTokenHeader(): HttpHeaders {
    let reqOptions = new HttpHeaders().set('Content-Type', 'application/json').append('Access-Control-Allow-Origin', '*');
    if (this.token) {
      reqOptions = new HttpHeaders().set('Content-Type', 'application/json').set('Authorization', 'Bearer ' + this.token);
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

  hasPermissionOnEntity(entity: string, crudType: string): Boolean {
    let filtered = this.userPermissions.filter(perm => {
      var entityRg = new RegExp(entity, 'i');
      var crudRg = new RegExp(crudType, 'i');
      return perm.name.match(entityRg) && perm.name.match(crudRg);
    });
    return filtered ? filtered.length > 0 : false;
  }
}