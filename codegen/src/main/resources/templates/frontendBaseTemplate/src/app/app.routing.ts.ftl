
import { RouterModule, Routes } from '@angular/router';
import { ModuleWithProviders } from "@angular/core";
import { AuthGuard } from './core/auth-guard';
import { CanDeactivateGuard } from 'fastCodeCore';
<#if FlowableModule!false>
import { TaskRoutes } from ‘task’';
</#if>

const routes: Routes = [

    <#if FlowableModule!false>
    {path: 'task', children: TaskRoutes}
    </#if>
	{ path: '', redirectTo: '/', pathMatch: 'full' }, 
];

export const routingModule: ModuleWithProviders = RouterModule.forRoot(routes);
