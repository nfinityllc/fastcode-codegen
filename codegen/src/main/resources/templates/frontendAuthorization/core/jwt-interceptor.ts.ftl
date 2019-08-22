import { Injectable } from '@angular/core';
import { HttpRequest, HttpHandler, HttpEvent, HttpInterceptor, HttpResponse, HttpErrorResponse } from '@angular/common/http';
import { Observable, throwError } from 'rxjs';
import { tap, catchError } from 'rxjs/operators';
@Injectable()
export class JwtInterceptor implements HttpInterceptor {

    intercept(request: HttpRequest<any>, next: HttpHandler): Observable<HttpEvent<any>> {
        // add authorization header with jwt token if available
       
        let token = localStorage.getItem('token');

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