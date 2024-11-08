import { Component } from '@angular/core';

@Component({
  selector: 'app-pessoas-table',
  templateUrl: './pessoas-table.component.html'
})
export class PessoasTableComponent {
  // Definindo as colunas da tabela
  columns = [
    { property: 'nome', label: 'Nome' },
    { property: 'idade', label: 'Idade', type: 'number' },
    { property: 'cidade', label: 'Cidade' },
    { property: 'profissao', label: 'Profissão' }
  ];

  // Definindo os itens fictícios
  items = [
    { nome: 'João Silva', idade: 28, cidade: 'São Paulo', profissao: 'Engenheiro' },
    { nome: 'Maria Oliveira', idade: 34, cidade: 'Rio de Janeiro', profissao: 'Designer' },
    { nome: 'Carlos Souza', idade: 45, cidade: 'Belo Horizonte', profissao: 'Desenvolvedor' },
    { nome: 'Ana Lima', idade: 29, cidade: 'Curitiba', profissao: 'Professora' },
    { nome: 'Pedro Santos', idade: 39, cidade: 'Salvador', profissao: 'Advogado' }
  ];
}
