import { Routes } from '@angular/router';
import { AboutComponent } from './components/about/about.component';
import { BrowseComponent } from './components/browse/browse.component';

export const routes: Routes = [
    {path: 'about', title: 'Sobre o Projeto', component: AboutComponent},
    {path: 'browse', title: 'Browse do Cadastro', component: BrowseComponent},
];