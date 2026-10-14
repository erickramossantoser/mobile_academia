# Entrega do Checkpoint 02

## O que o PDF pede

Entrega pela tarefa no **Teams**, até **14/10/2026 às 23h59**:

1. Link do repositório GitHub.
2. README atualizado.
3. Vídeo de até 5 minutos indicado no README; narração opcional.
4. Histórico de commits com mensagens coerentes.

O PDF não pede APK nem arquivo ZIP como entregável obrigatório.

## Arquivos preparados

- Código Flutter da parte 2, mantendo a parte 1 no histórico.
- README com projeto, descrição, ambiente, integrantes, execução e pacotes.
- `docs/demonstracao.mp4`: demonstração real do app no navegador em tamanho de celular.
- `docs/EXPLICACAO.md`: explicação do código para estudar.
- Ícone de halter e fontes locais.
- Testes dos principais fluxos.

## Antes de enviar no Teams

- Confira os nomes e RMs de Erick e Murilo no README.
- Assista ao vídeo inteiro e veja se o link abre.
- Confira se a branch `cp2-gerenciamento-acessos` já foi enviada ao GitHub.
- Abra o link da branch no navegador e confira se aparecem o README novo e o vídeo.
- Envie o link da branch na tarefa do Teams e finalize a entrega.

**Link da parte 2, após a publicação da branch:**

https://github.com/erickramossantoser/mobile_academia/tree/cp2-gerenciamento-acessos

Se a parte 2 ainda estiver apenas no computador, o link acima não funcionará. Para publicar os commits locais, execute na pasta do projeto:

```bash
git push -u origin cp2-gerenciamento-acessos
```

Se depois juntar a branch na principal, poderá usar o link normal do repositório. Entregar o link direto da branch evita que o professor abra somente a versão da parte 1.

## Onde cada requisito aparece

| Requisito do PDF | Implementação |
| --- | --- |
| Cadastro com TextField e TextEditingController | Formulário em `home_page.dart` |
| Nome, matrícula e data/hora | Classe `Pessoa` e cadastro |
| Lista com ListView | Lista de registros em `home_page.dart` |
| Entrada, saída e contador | `cadastrarPessoa`, `registrarSaida` e getter `presentes` |
| Capacidade máxima | Bloqueio em 20 pessoas |
| Feedback | `mostrarMensagem`, ScaffoldMessenger e SnackBar |
| Widget personalizado | `PessoaItem` |
| Objeto e função no construtor | `pessoa`, `onSaida` e `onExcluir` |
| Confirmação com AlertDialog | Saída e exclusão |
| Datas com intl | `DateFormat` em `pessoa_item.dart` |
| Organização dos arquivos | `models`, `screens` e `widgets` |
| SafeArea, Padding, SizedBox, Center, Expanded e Icon | Tela principal e card |
| Cores hexadecimais e Google Fonts | Tema azul e fonte Lato |
| Ícone personalizado | Halter, gerado com `flutter_launcher_icons` |
| Slidable com duas ações reais | SAÍDA e EXCLUIR |
| Campos obrigatórios e matrícula simultânea única | Validações do cadastro |
| Proibição de saída repetida | Validação e ação desabilitada |

## Se quiser gravar seu próprio vídeo

Use o app em um celular/emulador ou `flutter run -d chrome` e grave no máximo 5 minutos:

1. Mostre o nome do app, a academia e a capacidade de 20.
2. Tente cadastrar com campos vazios.
3. Cadastre duas pessoas e mostre nome, matrícula e data.
4. Tente repetir uma matrícula que ainda está presente.
5. Deslize um item, cancele uma saída e depois confirme.
6. Mostre a situação “Saiu” e o contador atualizado.
7. Exclua um registro e mostre a confirmação.
8. Mostre o aviso com 16 pessoas e o bloqueio em 20.
9. Mostre rapidamente a organização dos arquivos, se houver tempo.

O vídeo preparado demonstra o app executado pelo Flutter Web. A instalação e o ícone no launcher do Android precisam ser conferidos em um dispositivo Android, caso você queira mostrar essa parte.
