:- dynamic livro/4.
livro('O Senhor dos Aneis', 'J.R.R. Tolkien', 1954, '978-3-16-148410-0').
livro('1984', 'George Orwell', 1949, '978-0-452-28423-4').

:- dynamic lista_livros/2.
lista_livros('head', '978-3-16-148410-0'). % Início da lista
lista_livros('978-3-16-148410-0', '978-0-452-28423-4').
lista_livros('978-0-452-28423-4', 'nil'). % Fim da lista

:- dynamic membro/3.
membro('Alice Ferreira', '2023456', 'Engenharia de Software').
membro('Bruno Souza', '2023123', 'Ciência da Computação').
membro('Carla Menezes', '2023890', 'Engenharia Elétrica').

:- dynamic lista_membros/2.
lista_membros('head', '2023456').
lista_membros('2023456', '2023123').
lista_membros('2023123', '2023890').
lista_membros('2023890', 'nil').

:- dynamic emprestimo/4.
emprestimo('123', '2023456', '978-3-16-148410-0', '2024-11-01'). % Alice Ferreira
emprestimo('221', '2023123', '978-0-452-28423-4', '2024-11-03'). % Bruno Souza
emprestimo('314', '2023890', '978-0-19-953556-9', '2024-11-05'). % Carla Menezes

:- dynamic lista_emprestimos/2.
lista_emprestimos('head', '123').
lista_emprestimos('123', '221').
lista_emprestimos('221', '314').
lista_emprestimos('314', 'nil').

cadastrar_livro(Titulo, Autor, Ano, ISBN) :-
    assertz(livro(Titulo, Autor, Ano, ISBN)),
    lista_livros(Ultimo, 'nil'),
    retract(lista_livros(Ultimo, 'nil')),
    assertz(lista_livros(Ultimo, ISBN)),
    assertz(lista_livros(ISBN, 'nil')).

cadastrar_membro(Nome, Matricula, Curso) :-
    assertz(membro(Nome, Matricula, Curso)),
    lista_membros(Ultimo, 'nil'),
    retract(lista_membros(Ultimo, 'nil')),
    assertz(lista_membros(Ultimo, Matricula)),
    assertz(lista_membros(Matricula, 'nil')).

emprestar_livro(ID, Matricula, ISBN, DataEmprestimo) :-
    livro(_, _, _, ISBN),
    membro(_, Matricula, _),
	\+ emprestimo(ID, _, _, _),
	assertz(emprestimo(ID, Matricula, ISBN, DataEmprestimo)),
    lista_emprestimos(Ultimo, 'nil'),
    retract(lista_emprestimos(Ultimo, 'nil')),
    assertz(lista_emprestimos(Ultimo, ID)),
    assertz(lista_emprestimos(ID, 'nil')).

listar_livros :-
    lista_livros('head', Proximo),
    listar_livros_rec(Proximo).

listar_livros_rec('nil') :- !.
listar_livros_rec(ISBN) :-
    livro(Titulo, Autor, Ano, ISBN),
    format("Título: ~w, Autor: ~w, Ano: ~w, ISBN: ~w~n", [Titulo, Autor, Ano, ISBN]),
    lista_livros(ISBN, Proximo),
    listar_livros_rec(Proximo).

listar_membros :-
    lista_membros('head', Proximo),
    listar_membros_rec(Proximo).

listar_membros_rec('nil') :- !.
listar_membros_rec(Matricula) :-
    membro(Nome, Matricula, Curso),
    format("Nome: ~w, Matrícula: ~w, Curso: ~w~n", [Nome, Matricula, Curso]),
    lista_membros(Matricula, Proximo),
    listar_membros_rec(Proximo).

listar_emprestimos :-
    lista_emprestimos('head', Proximo),
    listar_emprestimos_rec(Proximo).

listar_emprestimos_rec('nil') :- !.
listar_emprestimos_rec(ID) :-
    emprestimo(ID, Matricula, ISBN, DataEmprestimo),
    format("ID: ~w, Matricula: ~w, ISBN: ~w, DataEmprestimo: ~w~n", [ID, Matricula, ISBN, DataEmprestimo]),
    lista_emprestimos(ID, Proximo),
    listar_emprestimos_rec(Proximo).

consultar_livro_por_titulo(Titulo) :-
    livro(Titulo, Autor, Ano, ISBN),
    format("Título: ~w, Autor: ~w, Ano: ~w, ISBN: ~w~n", [Titulo, Autor, Ano, ISBN]).

consultar_livro_por_autor(Autor) :-
    livro(Titulo, Autor, Ano, ISBN),
    format("Título: ~w, Autor: ~w, Ano: ~w, ISBN: ~w~n", [Titulo, Autor, Ano, ISBN]).

consultar_livro_por_ano(Ano) :-
    livro(Titulo, Autor, Ano, ISBN),
    format("Título: ~w, Autor: ~w, Ano: ~w, ISBN: ~w~n", [Titulo, Autor, Ano, ISBN]).

consultar_livro_por_isbn(ISBN) :-
    livro(Titulo, Autor, Ano, ISBN),
    format("Título: ~w, Autor: ~w, Ano: ~w, ISBN: ~w~n", [Titulo, Autor, Ano, ISBN]).

consultar_livros_por_membro(Matricula) :-
    emprestimo(_, Matricula, ISBN, DataEmprestimo),
    livro(Titulo, Autor, Ano, ISBN),
    format("Matrícula: ~w, Livro[Título: ~w, Autor: ~w, Ano: ~w, ISBN: ~w], Data de Empréstimo: ~w~n", [Matricula, Titulo, Autor, Ano, ISBN, DataEmprestimo]).

% relatorio_livros_disponiveis :-

% relatorio_livros_emprestados :-
    
% 4. Consultas
% Consultar livros: por título, por autor, por ano, emprestados a um
% membro, listar todos os livros, listar todos os membros, relatório de
% livros disponíveis, relatório de livros emprestados
