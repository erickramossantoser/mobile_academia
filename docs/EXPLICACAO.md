# Explicação do projeto

## O que mudou da parte 1 para a parte 2?

Na parte 1, o aplicativo tinha apenas um número: `pessoas`. Os botões ENTROU e SAIU aumentavam ou diminuíam esse número.

Na parte 2, cada entrada possui nome, matrícula e horário. Por isso, o número foi substituído por uma `List<Pessoa>`. A quantidade exibida é calculada contando somente os registros sem data de saída.

A academia continua com capacidade de 20 pessoas e aviso de quase cheia a partir de 16. A imagem de fundo e o azul foram mantidos, com o formulário e os registros acrescentados abaixo do resumo.

## 1. main.dart: inicia o aplicativo

`main()` chama `runApp`. O widget `MeuApp` configura o `MaterialApp`, as cores, a fonte Lato e a tela inicial.

A fonte é usada pelo pacote Google Fonts, mas os arquivos estão nos assets. Assim, não é necessário buscar a fonte na internet ao iniciar.

## 2. Pessoa: representa um registro

Em `models/pessoa.dart`, a classe `Pessoa` reúne:

- `nome`: nome informado.
- `identificacao`: matrícula informada.
- `dataEntrada`: data e hora do cadastro/entrada.
- `dataSaida`: começa como `null` e recebe um horário quando a pessoa sai.

O getter `noAmbiente` retorna se `dataSaida == null`. Ele evita manter um segundo campo de situação que poderia ficar diferente da data de saída.

`final` indica que o nome, a matrícula e a entrada desse registro não mudam depois da criação. A saída pode mudar, então não é `final`. O ponto de interrogação em `DateTime?` permite que a saída seja nula.

## 3. HomePage: guarda os dados e aplica as regras

`HomePage` é um `StatefulWidget` porque a lista muda com o uso.

Os dois `TextEditingController` permitem ler o conteúdo dos `TextField`. Ao cadastrar, o método:

1. Lê e remove espaços das extremidades.
2. Verifica se nome e matrícula foram preenchidos.
3. Verifica se a matrícula já está no ambiente.
4. Verifica o limite de 20 pessoas.
5. Cria uma `Pessoa` com `DateTime.now()` e coloca no início da lista.
6. Usa `setState` para atualizar a interface, limpa os campos e mostra uma mensagem.

`dispose()` libera os controllers quando a tela é removida.

A expressão `pessoas.where((pessoa) => pessoa.noAmbiente).length` filtra os presentes e conta os resultados. Assim, não precisamos aumentar e diminuir um contador separado.

## 4. PessoaItem: widget personalizado e passagem de função

O arquivo `widgets/pessoa_item.dart` representa cada pessoa da lista. Ele recebe pelo construtor:

- Um objeto `Pessoa`.
- A função `onSaida`.
- A função `onExcluir`.

Na tela principal, o uso é:

```dart
PessoaItem(
  pessoa: pessoa,
  onSaida: () => registrarSaida(pessoa),
  onExcluir: () => excluirPessoa(pessoa),
)
```

O card cuida da apresentação e avisa a tela principal quando uma ação é solicitada. A tela principal é quem altera os dados. Esse é o exemplo de comunicação entre widgets pedido no PDF.

`VoidCallback` é o tipo de uma função sem parâmetros e sem retorno. A expressão `() => registrarSaida(pessoa)` cria essa função, guardando a pessoa que deverá sair.

## 5. Slidable, confirmação e feedback

O `Slidable` abre duas ações ao arrastar para a esquerda. `SAÍDA` chama `onSaida`, e `EXCLUIR` chama `onExcluir`.

Antes de alterar o registro, a tela mostra um `AlertDialog`. `showDialog<bool>` aguarda uma resposta: confirmar devolve `true`, e cancelar devolve `false`. Fechar o diálogo sem escolher também é tratado como cancelamento.

`async/await` permite esperar pela resposta. Depois dessa espera, `mounted` verifica se a tela ainda existe antes de atualizar o estado.

Na saída, o registro continua na lista, recebe a data de saída e passa a mostrar “Saiu”. O botão de saída fica desabilitado. Na exclusão, o registro é removido da lista.

`ScaffoldMessenger` mostra uma `SnackBar` para informar o resultado ou o motivo de um bloqueio.

## 6. Datas e organização da tela

`DateFormat('dd/MM/yyyy HH:mm')`, do pacote `intl`, transforma um `DateTime` em um horário legível.

`SafeArea` evita áreas reservadas do aparelho. `Padding` e `SizedBox` criam espaçamento. `Expanded` deixa a lista ocupar o espaço restante, e `ListView` permite rolar os registros e o formulário.

## Como explicar em poucas palavras

“O app evoluiu de um contador para uma lista de pessoas. Cada cadastro registra uma entrada. Eu conto somente quem ainda não tem data de saída. O card recebe o objeto Pessoa e funções da tela principal. Quando deslizo o card e confirmo uma ação, a tela atualiza a lista com setState e mostra uma SnackBar.”

Antes de apresentar, execute o app e confira cada parte do código. O projeto usa dados em memória; reiniciar limpa os registros. A demonstração e os testes locais não substituem um teste no seu aparelho Android, caso você vá apresentá-lo nele.
