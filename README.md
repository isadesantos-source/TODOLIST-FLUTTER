O projeto foi implementado através dos conteúdos apresentados no ava durante as semanas.
Foi utilizado o Flutter para a construção das páginas e navegação entre elas. A atividade foi implementada nos arquivos: main.dart (responsável por inicializar o aplicativo, login.dart (tela de login/cadastro), calendarpage.dart (tela para selecionar a data no calendário) e por fim, ToDoListPage (tela que o usuário adiciona, visualiza e remove as atividades da lista de tarefas). Para navegar entre as telas foi utilizado o Navigator.push, como em aula, seguindo o padrão de empilhamento.
Na tela de login, foi implementada uma validação simples e dados fixos para o login:
Então o login para entrar é:

Email: loginteste@gmail.com 
Senha:2242

Caso os dados sejam inseridos incorretamente em login/senha, aparecerá uma mensagem informando que o login/senha estão incorretos. O usuário tem opção de se cadastrar e aparecerá uma mensagem na tela: 'Cadastro realizado', mas no firebase não estará sendo propriamente salvo.
Na tela calendário, foi utilizado o widget TableCalendar para selecionar uma data específica ao clicar na data desejada, e ao clicar, será aberto a tela de Lista de tarefas.
Na tela Lista de Tarefas, foram implementadas funcionalidades de adicionar, remover e marcar tarefas como concluídas. As tarefas estão sendo exibidas conforme solicitado: tarefas pendentes e em seguida, as concluídas, sendo ambas em ordem alfabética. Essa ordenação foi feita pelo método sort. Para melhor organização dos dados foi utilizada uma lista de objetos da classe Task. Na lista de tarefas foi utilizado o firebase para armazenar as tarefas, permitindo que os dados permaneçam salvos mesmo após sair da tela de Lista de Tarefas.
Em resumo, o projeto foi organizado buscando uma interface com tema escuro e melhor experiência visual.
