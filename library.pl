
% DEFINIÇÃO DOS FATOS

% Definição dos livros
:- dynamic livro/4.
livro('O Senhor dos Aneis', 'J.R.R. Tolkien', 1954, '978-3-16-148410-0').
livro('1984', 'George Orwell', 1949, '978-0-452-28423-4').

% Definição da lista de livros
:- dynamic lista_livros/2.
lista_livros('head', '978-3-16-148410-0').
lista_livros('978-3-16-148410-0', '978-0-452-28423-4').
lista_livros('978-0-452-28423-4', 'nil').

% Definição dos membros
:- dynamic membro/3.
membro('Alice Ferreira', '2023456', 'Engenharia de Software').
membro('Bruno Souza', '2023123', 'Ciência da Computação').
membro('Carla Menezes', '2023890', 'Engenharia Elétrica').

% Definição da lista de membros
:- dynamic lista_membros/2.
lista_membros('head', '2023456').
lista_membros('2023456', '2023123').
lista_membros('2023123', '2023890').
lista_membros('2023890', 'nil').

% Definição dos empréstimos
:- dynamic emprestimo/4.
emprestimo('123', '2023456', '978-3-16-148410-0', '2024-11-01'). % Alice Ferreira <- O Senhor dos Aneis
emprestimo('221', '2023123', '978-0-452-28423-4', '2024-11-03'). % Bruno Souza <- 1984

% Definição da lista de empréstimos
:- dynamic lista_emprestimos/2.
lista_emprestimos('head', '123').
lista_emprestimos('123', '221').
lista_emprestimos('221', 'nil').

% DEFINIÇÃO DAS REGRAS

% Definição do cadastro de livros
cadastrar_livro(Titulo, Autor, Ano, ISBN) :-
    assertz(livro(Titulo, Autor, Ano, ISBN)),
    lista_livros(Ultimo, 'nil'),
    retract(lista_livros(Ultimo, 'nil')),
    assertz(lista_livros(Ultimo, ISBN)),
    assertz(lista_livros(ISBN, 'nil')).

% Definição do cadastro de membros
cadastrar_membro(Nome, Matricula, Curso) :-
    assertz(membro(Nome, Matricula, Curso)),
    lista_membros(Ultimo, 'nil'),
    retract(lista_membros(Ultimo, 'nil')),
    assertz(lista_membros(Ultimo, Matricula)),
    assertz(lista_membros(Matricula, 'nil')).

% Definição do cadastro de empréstimos
emprestar_livro(ID, Matricula, ISBN, DataEmprestimo) :-
    livro(_, _, _, ISBN),
    membro(_, Matricula, _),
	\+ emprestimo(ID, _, _, _),
	assertz(emprestimo(ID, Matricula, ISBN, DataEmprestimo)),
    lista_emprestimos(Ultimo, 'nil'),
    retract(lista_emprestimos(Ultimo, 'nil')),
    assertz(lista_emprestimos(Ultimo, ID)),
    assertz(lista_emprestimos(ID, 'nil')).

% Definição da devolução de livros (remover o empréstimo pelo ID)
devolver_livro(ID) :-
    emprestimo(ID, Matricula, ISBN, DataEmprestimo),
    retract(emprestimo(ID, Matricula, ISBN, DataEmprestimo)),
    lista_emprestimos(Anterior, ID),
    lista_emprestimos(ID, Proximo),
    ( Anterior == 'head' ->
        ( Proximo == 'nil' ->
            retract(lista_emprestimos('head', ID)),
            assertz(lista_emprestimos('head', 'nil'))
        ;
            retract(lista_emprestimos('head', ID)),
            assertz(lista_emprestimos('head', Proximo))
        )
    ; Proximo == 'nil' ->
        retract(lista_emprestimos(Anterior, ID)),
        assertz(lista_emprestimos(Anterior, 'nil'))
    ;
        retract(lista_emprestimos(Anterior, ID)),
        assertz(lista_emprestimos(Anterior, Proximo))
    ),
    format("Livro devolvido com sucesso: [ID: ~w, Matrícula: ~w, ISBN: ~w, Data do Empréstimo: ~w]~n", 
           [ID, Matricula, ISBN, DataEmprestimo]).

% Definição da listagem de livros
listar_livros :-
    lista_livros('head', Proximo),
    listar_livros_rec(Proximo).

% Definição da listagem recursiva de livros
listar_livros_rec('nil') :- !.
listar_livros_rec(ISBN) :-
    livro(Titulo, Autor, Ano, ISBN),
    format("Título: ~w, Autor: ~w, Ano: ~w, ISBN: ~w~n", [Titulo, Autor, Ano, ISBN]),
    lista_livros(ISBN, Proximo),
    listar_livros_rec(Proximo).

% Definição da listagem de membros
listar_membros :-
    lista_membros('head', Proximo),
    listar_membros_rec(Proximo).

% Definição da listagem recursiva de membros
listar_membros_rec('nil') :- !.
listar_membros_rec(Matricula) :-
    membro(Nome, Matricula, Curso),
    format("Nome: ~w, Matrícula: ~w, Curso: ~w~n", [Nome, Matricula, Curso]),
    lista_membros(Matricula, Proximo),
    listar_membros_rec(Proximo).

% Definição da listagem de emprestimos
listar_emprestimos :-
    lista_emprestimos('head', Proximo),
    listar_emprestimos_rec(Proximo).

% Definição da listagem recursiva de empréstimos
listar_emprestimos_rec('nil') :- !.
listar_emprestimos_rec(ID) :-
    emprestimo(ID, Matricula, ISBN, DataEmprestimo),
    format("ID: ~w, Matricula: ~w, ISBN: ~w, DataEmprestimo: ~w~n", [ID, Matricula, ISBN, DataEmprestimo]),
    lista_emprestimos(ID, Proximo),
    listar_emprestimos_rec(Proximo).

% Definição da consulta de livros por titulo
consultar_livro_por_titulo(Titulo) :-
    livro(Titulo, Autor, Ano, ISBN),
    format("Título: ~w, Autor: ~w, Ano: ~w, ISBN: ~w~n", [Titulo, Autor, Ano, ISBN]).

% Definição da consulta de livros por autor
consultar_livro_por_autor(Autor) :-
    livro(Titulo, Autor, Ano, ISBN),
    format("Título: ~w, Autor: ~w, Ano: ~w, ISBN: ~w~n", [Titulo, Autor, Ano, ISBN]).

% Definição da consulta de livros por ano
consultar_livro_por_ano(Ano) :-
    livro(Titulo, Autor, Ano, ISBN),
    format("Título: ~w, Autor: ~w, Ano: ~w, ISBN: ~w~n", [Titulo, Autor, Ano, ISBN]).

% Definição da consulta de livros por ISBN
consultar_livro_por_isbn(ISBN) :-
    livro(Titulo, Autor, Ano, ISBN),
    format("Título: ~w, Autor: ~w, Ano: ~w, ISBN: ~w~n", [Titulo, Autor, Ano, ISBN]).

% Definição da consulta de livros emprestados a um membro
consultar_livros_por_membro(Matricula) :-
    emprestimo(_, Matricula, ISBN, DataEmprestimo),
    livro(Titulo, Autor, Ano, ISBN),
    format("Matrícula: ~w, Livro[Título: ~w, Autor: ~w, Ano: ~w, ISBN: ~w], Data de Empréstimo: ~w~n", [Matricula, Titulo, Autor, Ano, ISBN, DataEmprestimo]).

% Definição do relatório de livros disponíveis
relatorio_livros_disponiveis :- 
    lista_livros('head', Proximo),
    relatorio_livros_disponiveis_rec(Proximo).

relatorio_livros_disponiveis_rec('nil') :- !.
relatorio_livros_disponiveis_rec(ISBN) :- 
    livro(Titulo, Autor, Ano, ISBN),
    \+ emprestimo(_, _, ISBN, _),
    format("Livro Disponível: [Título: ~w, Autor: ~w, Ano: ~w, ISBN: ~w]~n", [Titulo, Autor, Ano, ISBN]),
    lista_livros(ISBN, Proximo),
    relatorio_livros_disponiveis_rec(Proximo).

% Definição do relatório de livros emprestados
relatorio_livros_emprestados :- 
    lista_livros('head', Proximo),
    relatorio_livros_emprestados_rec(Proximo).

relatorio_livros_emprestados_rec('nil') :- !.
relatorio_livros_emprestados_rec(ISBN) :- 
    livro(Titulo, Autor, Ano, ISBN),
    emprestimo(_, _, ISBN, DataEmprestimo),
    format("Livro Emprestado: [Título: ~w, Autor: ~w, Ano: ~w, ISBN: ~w, Data de Empréstimo: ~w]~n", [Titulo, Autor, Ano, ISBN, DataEmprestimo]),
    lista_livros(ISBN, Proximo),
    relatorio_livros_emprestados_rec(Proximo).

% 4. Consultas
% Consultar livros: por título, por autor, por ano, emprestados a um
% membro, listar todos os livros, listar todos os membros, relatório de
% livros disponíveis, relatório de livros emprestados
