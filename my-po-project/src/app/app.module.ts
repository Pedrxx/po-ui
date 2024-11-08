import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { PoModule } from '@po-ui/ng-components';
import { RouterModule } from '@angular/router';

import { ProtheusLibCoreModule } from '@totvs/protheus-lib-core';
import { PessoasTableComponent } from './pessoas-table/pessoas-table.component';
import { PedidosDeVendaComponent } from './pedidos-de-venda/pedidos-de-venda.component';


@NgModule({
  declarations: [
    AppComponent,
    PessoasTableComponent,
    PedidosDeVendaComponent
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    PoModule,
    RouterModule.forRoot([]),
    ProtheusLibCoreModule
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }
