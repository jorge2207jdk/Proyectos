:- ensure_loaded(library(lists)).


invertir(Lista, Invertida) :- 
    invertir_aux(Lista, [], Invertida).

invertir_aux([], Acc, Acc).
invertir_aux([H|T], Acc, Invertida) :-
    invertir_aux(T, [H|Acc], Invertida).


programa :-
    write(' INVERSOR DE LISTAS '), nl, nl,
    menu.

menu :-
    repeat,
    write('Ingrese una lista (ejemplo: [1,2,3,4])'), nl,
    write('O escriba "salir." para terminar: '), nl,
    read(Entrada),
    (   Entrada = salir
    ->  write('¡Vuelva Pronto!'), nl, !
    ;   procesar_entrada(Entrada),
        nl,
        fail
    ).

procesar_entrada(Lista) :-
    (   is_list(Lista)
    ->  invertir(Lista, Resultado),
        write('Lista original:  '), write(Lista), nl,
        write('Lista invertida: '), write(Resultado), nl
    ;   write('ERROR: Debe ingresar una lista válida.'), nl
    ).