import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { PoModule } from '@po-ui/ng-components';
import { RouterModule, RouterOutlet } from '@angular/router';

import { ProtheusLibCoreModule } from '@totvs/protheus-lib-core';
import { PoTemplatesModule } from '@po-ui/ng-templates';
import { BrowseComponent } from './components/browse/browse.component';
import { AboutComponent } from './components/about/about.component';





@NgModule({
  declarations: [
    AppComponent,
    BrowseComponent,
    AboutComponent,
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    PoModule,
    RouterModule.forRoot([]),
    ProtheusLibCoreModule,
    PoTemplatesModule,
    RouterOutlet
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }
