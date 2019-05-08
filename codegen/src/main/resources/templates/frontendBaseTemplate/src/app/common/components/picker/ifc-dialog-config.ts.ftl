import { Observable } from 'rxjs';
export interface IFCDialogConfig {
  DataSource: Observable<any>;
  Title: string;
  IsSingleSelection?:boolean;
  DisplayField: string;
  //OnClose: Observable<any>;
 
 }
