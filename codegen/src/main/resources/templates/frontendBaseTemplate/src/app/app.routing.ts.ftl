
import { RouterModule, Routes } from '@angular/router';
import { ModuleWithProviders } from "@angular/core";
import { AuthGuard } from './core/auth-guard';
import { CanDeactivateGuard } from 'fastCodeCore';
import { HomeComponent } from './home/home.component';
import { DashboardComponent } from './dashboard/dashboard.component';
<#if AuthenticationType != "none">
import { LoginComponent } from './login/index';
</#if>
<#if FlowableModule!false>
import { TaskRoutes } from ‘task’';
</#if>

const routes: Routes = [

	{ path: '', component: HomeComponent },
	{ path: 'dashboard',  component: DashboardComponent ,canActivate: [ AuthGuard ]  },
	<#if AuthenticationType != "none">	
	{ path: 'login', component: LoginComponent },
	{ path: 'login/:returnUrl', component: LoginComponent },
	</#if>
    <#if FlowableModule!false>
    {path: 'task', children: TaskRoutes},
    </#if>
	{ path: '', redirectTo: '/', pathMatch: 'full' }, 
];

export const routingModule: ModuleWithProviders = RouterModule.forRoot(routes);
