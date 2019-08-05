
import { RouterModule, Routes } from '@angular/router';
import { ModuleWithProviders } from "@angular/core";
import { AuthGuard } from './core/auth-guard';
<#if FlowableModule!false>
import { TaskRoutes } from ‘task’';
</#if>
<#if SchedulerModule!false>
import { SchedulerRoutes } from 'scheduler';
</#if>

const routes: Routes = [

    <#if FlowableModule!false>
    {path: 'task', children: TaskRoutes},
    </#if>
    <#if SchedulerModule!false>
    {path: 'scheduler', children: SchedulerRoutes},
    </#if>
	{ path: '', redirectTo: '/', pathMatch: 'full' }, 
];

export const routingModule: ModuleWithProviders = RouterModule.forRoot(routes);
