
import { RouterModule, Routes } from '@angular/router';
import { ModuleWithProviders } from "@angular/core";
import { AppComponent } from './app.component';
import { AuthGuard } from './core/auth-guard';

const routes: Routes = [
  
    { path: '', redirectTo: '/', pathMatch: 'full' },
   
];

export const routingModule: ModuleWithProviders = RouterModule.forRoot(routes);