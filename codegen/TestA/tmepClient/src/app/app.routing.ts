import { TagdetailsListComponent , TagdetailsDetailsComponent, TagdetailsNewComponent } from './tagdetails/index';
import { PostListComponent , PostDetailsComponent, PostNewComponent } from './post/index';
import { TagListComponent , TagDetailsComponent, TagNewComponent } from './tag/index';
import { PostdetailsListComponent , PostdetailsDetailsComponent, PostdetailsNewComponent } from './postdetails/index';

import { RouterModule, Routes } from '@angular/router';
import { ModuleWithProviders } from "@angular/core";
import { CanDeactivateGuard } from 'fastCodeCore';
import { HomeComponent } from './home/home.component';
import { DashboardComponent } from './dashboard/dashboard.component';

const routes: Routes = [

	
	{ path: 'dashboard',  component: DashboardComponent   },
    { path: '', component: HomeComponent },

   { path: 'tagdetails', component: TagdetailsListComponent, canDeactivate: [CanDeactivateGuard] },
   { path: 'tagdetails/new', component: TagdetailsNewComponent },
   { path: 'tagdetails/:id', component: TagdetailsDetailsComponent, canDeactivate: [CanDeactivateGuard] },

   { path: 'post', component: PostListComponent, canDeactivate: [CanDeactivateGuard] },
   { path: 'post/new', component: PostNewComponent },
   { path: 'post/:id', component: PostDetailsComponent, canDeactivate: [CanDeactivateGuard] },

   { path: 'tag', component: TagListComponent, canDeactivate: [CanDeactivateGuard] },
   { path: 'tag/new', component: TagNewComponent },
   { path: 'tag/:id', component: TagDetailsComponent, canDeactivate: [CanDeactivateGuard] },

   { path: 'postdetails', component: PostdetailsListComponent, canDeactivate: [CanDeactivateGuard] },
   { path: 'postdetails/new', component: PostdetailsNewComponent },
   { path: 'postdetails/:id', component: PostdetailsDetailsComponent, canDeactivate: [CanDeactivateGuard] },
	{ path: '', redirectTo: '/', pathMatch: 'full' }, 
];

export const routingModule: ModuleWithProviders = RouterModule.forRoot(routes);

