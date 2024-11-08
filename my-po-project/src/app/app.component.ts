import { Component } from '@angular/core';

import { PoMenuItem } from '@po-ui/ng-components';

import { ProAppConfigService } from '@totvs/protheus-lib-core';

import { RouterOutlet,Router } from '@angular/router';


@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent {

  constructor(private proAppConfigService: ProAppConfigService, private router: Router) { 
    if (!this.proAppConfigService.insideProtheus()) {
        this.proAppConfigService.loadAppConfig();
      }
  }

  readonly menus: Array<PoMenuItem> = [
    { label: 'Cadastro do Grupo', action: this.browseClick.bind(this), icon: 'po-icon po-icon-clipboard', shortLabel: 'Cadastro' },
    { label: 'Ajuda (Help)', action: this.aboutClick.bind(this), icon: 'po-icon po-icon-help', shortLabel: 'Ajuda' },
    { label: 'Sair', action: this.closeApp.bind(this), icon: 'po-icon po-icon-exit', shortLabel: 'Sair' },
  ];


  private browseClick() {
    this.router.navigate(['/','browse']);
  }
  
  private aboutClick() {
    this.router.navigate(['/','about']);
  }

  private closeApp() {
    if (this.proAppConfigService.insideProtheus()) {
        this.proAppConfigService.callAppClose();
    } else {
        alert('O App não está sendo executado dentro do Protheus.');
      }
  }

}
