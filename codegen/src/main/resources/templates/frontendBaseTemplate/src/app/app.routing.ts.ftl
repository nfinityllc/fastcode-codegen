
import { RouterModule, Routes } from '@angular/router';
import { ModuleWithProviders } from "@angular/core";
import { AppComponent } from './app.component';
import { AuthGuard } from './core/auth-guard';
import { AddFilterFieldComponent } from './common/components/list-filters/add-filter-field/add-filter-field.component';

const routes: Routes = [
	{ path: 'addFilterFieldDialog', component: AddFilterFieldComponent },
	{ path: '', redirectTo: '/', pathMatch: 'full' }, 
];

export const routingModule: ModuleWithProviders = RouterModule.forRoot(routes);
