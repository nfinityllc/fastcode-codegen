import { Injectable } from '@angular/core';
import { HttpRequest, HttpHandler, HttpEvent, HttpInterceptor, HttpResponse, HttpErrorResponse } from '@angular/common/http';
import { Observable, throwError } from 'rxjs';
import { tap, catchError } from 'rxjs/operators';
<#if AuthenticationType == 'oidc'>
import { OAuthStorage } from 'angular-oauth2-oidc';
import { CoreEnvironment } from '@angular/compiler/src/compiler_facade_interface';
import {environment} from '../../environments/environment';
</#if>
@Injectable()
export class JwtInterceptor implements HttpInterceptor {

	<#if AuthenticationType == 'oidc'>
	constructor(private authStorage: OAuthStorage){
	}
	
	</#if>
    intercept(request: HttpRequest<any>, next: HttpHandler): Observable<HttpEvent<any>> {
        // add authorization header with jwt token if available
       
        let token = localStorage.getItem('token');
        <#if AuthenticationType == 'oidc'>
		token= this.authStorage.getItem('access_token');
		token = token? ("Bearer " + token) : token;
  		</#if>           
        if (token) {
            request = request.clone({
                setHeaders: { 
                    Authorization: token,
                    Accept:'application/json'
                }
            });
        }

        return next.handle(request);/*.pipe(
            tap((ev: HttpEvent<any>) => {
              if (ev instanceof HttpResponse) {
                console.log('processing response', ev);
              }
            }),
            catchError(response => {
                if (response instanceof HttpErrorResponse) {
                  console.log('Processing http error', response);
                }
     
                return throwError(response);	 
          })
        )*/
    }
}