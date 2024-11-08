# Setup do Ambiente para Protheus com Angular e Node.js

## Requisitos

- [Node.js](https://nodejs.org/en/)
- NPM (gerenciador de pacotes do Node.js)
- Visual Studio Code (VSCode)

## Passo a Passo

1. Instale o Node.js e verifique a versão:

    ```bash
    node --version
    ```

2. Instale o Angular CLI globalmente:

    ```bash
    npm install -g @angular/cli@14
    ```

3. Crie o projeto Angular:

    ```bash
    ng new my-po-project --skip-install
    ```

4. Configure a política de execução no Windows (se necessário):

    ```bash
    Get-ExecutionPolicy -Scope CurrentUser
    Set-ExecutionPolicy -ExecutionPolicy Unrestricted
    ```

5. Instale o `windows-build-tools` (opcional):

    ```bash
    npm install --global --production windows-build-tools
    ```

6. Instale as dependências do projeto:

    ```bash
    npm install
    ```

7. Adicione os componentes do PO UI:

    ```bash
    ng add @po-ui/ng-components
    ```

8. Inicie o servidor de desenvolvimento:

    ```bash
    ng serve
    ```

    Acesse [http://localhost:4200](http://localhost:4200) para visualizar o projeto.

9. Pare o servidor pressionando `CTRL+C` ou `CTRL+BREAK` no terminal.

10. Adicione templates do PO UI:

    ```bash
    ng add @po-ui/ng-templates
    ```

11. Instale bibliotecas adicionais para integração com Protheus:

    ```bash
    npm install @totvs/protheus-lib-core@14.3.0
    npm install subsink
    npm install @totvs/po-theme@14
    ```

12. Configure o estilo no `angular.json`:

    ```json
    "styles": [
        "node_modules/@totvs/po-theme/css/po-theme-default-variables.min.css",
        "node_modules/@totvs/po-theme/css/po-theme-default.min.css",
        "node_modules/@po-ui/style/css/po-theme-core.min.css"
    ]
    ```

13. Importe a biblioteca no `app.module.ts`:

    ```typescript
    import { ProtheusLibCoreModule } from '@totvs/protheus-lib-core';
    ```

    Adicione `ProtheusLibCoreModule` no array de `imports`.

14. Configure o botão de sair no `app.component.ts`:

    ```typescript
    import { ProAppConfigService } from '@totvs/protheus-lib-core';

    constructor(private proAppConfigService: ProAppConfigService) { 
        if (!this.proAppConfigService.insideProtheus()) {
            this.proAppConfigService.loadAppConfig();
        }
    }

    private closeApp() {
        if (this.proAppConfigService.insideProtheus()) {
            this.proAppConfigService.callAppClose();
        } else {
            alert('O App não está sendo executado dentro do Protheus.');
        }
    }
    ```

15. Compile o projeto para uso no Protheus:

    ```bash
    ng build
    ```

    Renomeie para `.app` se necessário.

16. Documentação Adicional

- [Protheus e Porta Multiprotocolo](https://tdn.totvs.com/display/tec/Application+Server+-+Porta+Multiprotocolo)
- [TOTVS FwCallApp](https://tdn.totvs.com.br/display/public/framework/FwCallApp)

Este README fornece um guia rápido para configurar um projeto Angular integrado ao Protheus.
