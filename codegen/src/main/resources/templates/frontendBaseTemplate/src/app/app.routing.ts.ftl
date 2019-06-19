
import { RouterModule, Routes } from '@angular/router';
import { ModuleWithProviders } from "@angular/core";
import { AuthGuard } from './core/auth-guard';

const routes: Routes = [
	{ path: '', redirectTo: '/', pathMatch: 'full' }, 
];

export const routingModule: ModuleWithProviders = RouterModule.forRoot(routes);
