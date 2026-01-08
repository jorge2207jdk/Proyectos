invertir([], []).

invertir(Lista, Invertida) :-
    invertir_acc(Lista, [], Invertida).

invertir_acc([], Acumulador, Acumulador).
invertir_acc([Cabeza|Cola], Acumulador, Resultado) :-
    invertir_acc(Cola, [Cabeza|Acumulador], Resultado).


sumar_lista([], 0).

sumar_lista([Cabeza|Cola], Total) :-
    sumar_lista(Cola, SumaResto),
    Total is Cabeza + SumaResto.


ultimo_elemento([Ultimo], Ultimo).

ultimo_elemento([_|Cola], Ultimo) :-
    ultimo_elemento(Cola, Ultimo).

filtrar_mayores([], _, []).

filtrar_mayores([Cabeza|Cola], N, [Cabeza|Resto]) :-
    Cabeza > N,
    filtrar_mayores(Cola, N, Resto).

filtrar_mayores([Cabeza|Cola], N, Resto) :-
    Cabeza =< N,
    filtrar_mayores(Cola, N, Resto).

progenitor(juan, maria).
progenitor(juan, pedro).
progenitor(juan, ana).
progenitor(carmen, maria).
progenitor(carmen, pedro).
progenitor(carmen, ana).
progenitor(luis, carlos).
progenitor(luis, sofia).
progenitor(elena, carlos).

% Hechos: hombre(X)
hombre(juan).
hombre(pedro).
hombre(luis).
hombre(carlos).

% Hechos: mujer(Y)
mujer(carmen).
mujer(maria).
mujer(ana).
mujer(elena).
mujer(sofia).

es_hermano(X, Y) :-
    progenitor(Padre, X),
    progenitor(Padre, Y),
    X \= Y.
 ?- invertir([a, b, c, d], Resultado).
 ?- sumar_lista([10, 5, 2, 3], Total).
 ?- ultimo_elemento([prolog, ia, logica], Ultimo).
 ?- filtrar_mayores([10, 3, 15, 7, 20], 10, Resultado).
 ?- es_hermano(maria, pedro).
 ?- es_hermano(carlos, sofia).