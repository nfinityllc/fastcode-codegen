import { Injectable } from '@angular/core';
import { HttpClient,HttpHeaders, HttpErrorResponse } from '@angular/common/http';
import { Observable, of,throwError } from 'rxjs';
import { catchError, tap, map } from 'rxjs/operators';
import { environment } from 'src/environments/environment';
//import { IUser } from '../users/iuser';

const API_URL = environment.apiUrl;

@Injectable()
export class AuthenticationService {
  private _reqOptionsArgs= { headers: new HttpHeaders().set( 'Content-Type', 'application/json' ).append('Access-Control-Allow-Origin', '*') };

  private apiUrl =  'http://localhost:5555';
  constructor(private http: HttpClient ) { 
  }
  getMainUsers(): Observable<any> {
    
   return this.http.get<any[]>(this.apiUrl + '/users' ).pipe( catchError(this.handleError));
   
    }
  postLogin(user: any): Observable<any> {
      console.log("AFSD")
      return this.http.post<any>(this.apiUrl+'/login', user, this._reqOptionsArgs).pipe(map(res => {
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
  get token():string {
    return !localStorage.getItem("token") ? null : localStorage.getItem("token");
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
      errorMessage = 'An error occurred: ' + err.error.message;
    } else {
      
      errorMessage = 'Server returned code: ' + err.status + ', error message is: ' + err.message;
    }
    console.error(errorMessage);
    return throwError(errorMessage);
  }
  /** Log a HeroService message with the MessageService */
  private log(message: string) {
   console.log(message);
  }
}
