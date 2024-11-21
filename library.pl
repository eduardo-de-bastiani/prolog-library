% Base de Dados de Livros (ChatGPT gerou os livros)
:- dynamic livro/4.
:- dynamic lista_livros/2.

% Base inicial
livro('O Senhor dos Aneis', 'J.R.R. Tolkien', 1954, '978-3-16-148410-0').
livro('1984', 'George Orwell', 1949, '978-0-452-28423-4').

lista_livros('head', '978-3-16-148410-0'). % Início da lista
lista_livros('978-3-16-148410-0', '978-0-452-28423-4').
lista_livros('978-0-452-28423-4', 'nil'). % Fim da lista

% Base de Dados de Membros
:- dynamic membro/3.
membro('Alice Ferreira', 2023456, 'Engenharia de Software').
membro('Bruno Souza', 2023123, 'Ciência da Computação').
membro('Carla Menezes', 2023890, 'Engenharia Elétrica').
membro('Diego Martins', 2023674, 'Administração').
membro('Eduarda Lima', 2023567, 'Psicologia').
membro('Felipe Almeida', 2023987, 'Design Gráfico').
membro('Gabriela Torres', 2023777, 'Engenharia Mecânica').
membro('Henrique Lopes', 2023444, 'Medicina').
membro('Isabela Santos', 2023666, 'Biomedicina').
membro('João Pedro Rocha', 2023333, 'Direito').
membro('Karina Oliveira', 2023555, 'Arquitetura e Urbanismo').
membro('Lucas Andrade', 2023999, 'Física').
membro('Mariana Silva', 2023222, 'Letras').
membro('Nathalia Ribeiro', 2023111, 'Matemática').
membro('Otávio Farias', 2023888, 'Engenharia Civil').

% Base de Dados de Empréstimos
:- dynamic emprestimo/3.
emprestimo(2023456, '978-3-16-148410-0', '2024-11-01'). % Alice Ferreira
emprestimo(2023123, '978-0-452-28423-4', '2024-11-03'). % Bruno Souza
emprestimo(2023890, '978-0-19-953556-9', '2024-11-05'). % Carla Menezes
emprestimo(2023674, '978-85-06-02528-7', '2024-11-07'). % Diego Martins
emprestimo(2023567, '978-0-7475-3269-9', '2024-11-09'). % Eduarda Lima
emprestimo(2023987, '978-0-385-50420-1', '2024-11-10'). % Felipe Almeida
emprestimo(2023777, '978-1-5011-9762-5', '2024-11-11'). % Gabriela Torres
emprestimo(2023444, '978-0-316-76948-0', '2024-11-12'). % Henrique Lopes
emprestimo(2023666, '978-2-07-061275-8', '2024-11-13'). % Isabela Santos
emprestimo(2023333, '978-0-06-088328-7', '2024-11-14'). % João Pedro Rocha
emprestimo(2023555, '978-0-452-28424-1', '2024-11-15'). % Karina Oliveira
emprestimo(2023999, '978-0-14-044913-6', '2024-11-16'). % Lucas Andrade
emprestimo(2023222, '978-0-06-112241-5', '2024-11-17'). % Mariana Silva
emprestimo(2023111, '978-0-14-143984-6', '2024-11-18'). % Nathalia Ribeiro
emprestimo(2023888, '978-0-14-243720-9', '2024-11-19'). % Otávio Farias
emprestimo(2023456, '978-3-16-148410-0', '2024-11-02'). % Alice Ferreira (repetindo livro em outra data)
emprestimo(2023123, '978-0-7475-3269-9', '2024-11-06'). % Bruno Souza
emprestimo(2023890, '978-2-07-061275-8', '2024-11-08'). % Carla Menezes
emprestimo(2023674, '978-0-06-088328-7', '2024-11-09'). % Diego Martins
emprestimo(2023555, '978-0-14-243720-9', '2024-11-20'). % Karina Oliveira (segundo empréstimo)

% Cadastro de livro
cadastrar_livro(Titulo, Autor, Ano, ISBN) :-
    assertz(livro(Titulo, Autor, Ano, ISBN)),
    lista_livros(_, Tail),
    retract(lista_livros(_, Tail)),
    assertz(lista_livros(Tail, ISBN)),
    assertz(lista_livros(ISBN, 'nil')).

% Listar livros
listar_livros :-
    lista_livros('head', Proximo),
    listar_livros_rec(Proximo).

listar_livros_rec('nil') :- !. % Caso base
listar_livros_rec(ISBN) :-
    livro(Titulo, Autor, Ano, ISBN),
    format("Título: ~w, Autor: ~w, Ano: ~w, ISBN: ~w~n", [Titulo, Autor, Ano, ISBN]),
    lista_livros(ISBN, Proximo),
    listar_livros_rec(Proximo).

cadastrar_membro(Nome, Matricula, Curso) :-
    assertz(membro(Nome, Matricula, Curso)).

consultar_livro(Nome, Autor, Ano, ISBN) :-
    livro(Nome, Autor, Ano, ISBN).

emprestar_livro(Matricula, ISBN, DataEmprestimo) :-
  livro(_, _, _, ISBN),
  membro(_, Matricula, _),
  \+ emprestimo(Matricula, ISBN, _),
  assertz(emprestimo(Matricula, ISBN, DataEmprestimo)).