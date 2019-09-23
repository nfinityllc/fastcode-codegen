
import { RouterModule, Routes } from '@angular/router';
import { ModuleWithProviders } from "@angular/core";
import { CanDeactivateGuard } from 'fastCodeCore';
import { HomeComponent } from './home/home.component';
import { DashboardComponent } from './dashboard/dashboard.component';
<#if AuthenticationType != "none">
import { LoginComponent } from './login/index';
import { AuthGuard } from './core/auth-guard';
</#if>
<#if AuthenticationType == 'oidc'>
import { CallbackComponent } from './oauth/callback.component';
</#if>
<#if FlowableModule!false>
import { TaskRoutes } from ‘task’';
</#if>

const routes: Routes = [

	{ path: '', component: HomeComponent },
	{ path: 'dashboard',  component: DashboardComponent <#if AuthenticationType != "none">,canActivate: [ AuthGuard ]</#if>  },
	<#if AuthenticationType != "none">	
	{ path: 'login', component: LoginComponent },
	{ path: 'login/:returnUrl', component: LoginComponent },
	</#if>
    <#if FlowableModule!false>
	{path: 'task', children: TaskRoutes <#if AuthenticationType != "none">,canActivate: [ AuthGuard ]</#if>},
    </#if>
    <#if AuthenticationType == 'oidc'>
	{ path: 'callback', component: CallbackComponent },
	</#if>
	{ path: '', redirectTo: '/', pathMatch: 'full' }, 
];

export const routingModule: ModuleWithProviders = RouterModule.forRoot(routes);
