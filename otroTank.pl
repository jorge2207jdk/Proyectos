:- dynamic estado_cisterna/1.
:- dynamic estado_tanque/2.
:- dynamic nivel_agua_cisterna/1.
:- dynamic nivel_agua_tanque/2.
:- dynamic bomba_encendida/0.

retract_all :-
    retractall(estado_cisterna(_)),
    retractall(estado_tanque(_, _)),
    retractall(nivel_agua_cisterna(_)),
    retractall(nivel_agua_tanque(_, _)),
    retractall(bomba_encendida).

:- initialization(retract_all, now).

estado_posible_cisterna(vacia).
estado_posible_cisterna(suficiente).

estado_posible_tanque(bajo).
estado_posible_tanque(medio).
estado_posible_tanque(lleno).

nivel_minimo_cisterna(20).
nivel_maximo_cisterna(100).

nivel_bajo_tanque(30).
nivel_medio_tanque(70).
nivel_lleno_tanque(95).

inicializar_sistema :-
    assertz(estado_cisterna(suficiente)),
    assertz(nivel_agua_cisterna(80)),
    assertz(estado_tanque(tk1, bajo)),
    assertz(nivel_agua_tanque(tk1, 25)),
    assertz(estado_tanque(tk2, medio)),
    assertz(nivel_agua_tanque(tk2, 50)),
    retractall(bomba_encendida),
    write('Sistema inicializado.'), nl.

:- initialization(inicializar_sistema, now).

actualizar_estado_cisterna :-
    nivel_agua_cisterna(Nivel),
    nivel_minimo_cisterna(Minimo),
    (Nivel < Minimo -> 
        retractall(estado_cisterna(_)),
        assertz(estado_cisterna(vacia))
    ;
        retractall(estado_cisterna(_)),
        assertz(estado_cisterna(suficiente))
    ).

actualizar_estado_tanque(Tanque) :-
    nivel_agua_tanque(Tanque, Nivel),
    nivel_bajo_tanque(Bajo),
    nivel_medio_tanque(Medio),
    nivel_lleno_tanque(Lleno),
    (Nivel < Bajo ->
        retractall(estado_tanque(Tanque, _)),
        assertz(estado_tanque(Tanque, bajo))
    ; Nivel < Medio ->
        retractall(estado_tanque(Tanque, _)),
        assertz(estado_tanque(Tanque, medio))
    ; Nivel >= Lleno ->
        retractall(estado_tanque(Tanque, _)),
        assertz(estado_tanque(Tanque, lleno))
    ;
        retractall(estado_tanque(Tanque, _)),
        assertz(estado_tanque(Tanque, medio))
    ).

actualizar_todos_estados :-
    actualizar_estado_cisterna,
    actualizar_estado_tanque(tk1),
    actualizar_estado_tanque(tk2).

debe_apagar_bomba :-
    estado_cisterna(vacia),
    write('Cisterna vacia.'), nl.

debe_apagar_bomba :-
    estado_tanque(tk1, lsleno),
    estado_tanque(tk2, lleno),
    write('Tanques llenos.'), nl.

debe_encender_bomba :-
    estado_cisterna(suficiente),
    (estado_tanque(tk1, bajo) ; estado_tanque(tk2, bajo)),
    ((estado_tanque(tk1, bajo), estado_tanque(tk2, bajo)) ->
        write('Tanques bajos.'), nl
    ; estado_tanque(tk1, bajo) ->
        write('Tanque 1 bajo.'), nl
    ; 
        write('Tanque 2 bajo.'), nl
    ).

controlar_bomba :-
    write('Evaluando...'), nl,
    mostrar_estado_actual,
    (debe_apagar_bomba ->
        apagar_bomba,
        write('Bomba APAGADA.'), nl
    ; debe_encender_bomba ->
        encender_bomba,
        write('Bomba ENCENDIDA.'), nl
    ;
        write('No hay necesidad.'), nl,
        apagar_bomba,
        write('Bomba APAGADA.'), nl
    ).

encender_bomba :-
    retractall(bomba_encendida),
    assertz(bomba_encendida).

apagar_bomba :-
    retractall(bomba_encendida).

esta_encendida :-
    bomba_encendida.

esta_apagada :-
    \+ bomba_encendida.

mostrar_estado_actual :-
    estado_cisterna(EstadoCisterna),
    nivel_agua_cisterna(NivelCisterna),
    estado_tanque(tk1, EstadoTk1),
    nivel_agua_tanque(tk1, NivelTk1),
    estado_tanque(tk2, EstadoTk2),
    nivel_agua_tanque(tk2, NivelTk2),
    (bomba_encendida -> EstadoBomba = 'ENCENDIDA' ; EstadoBomba = 'APAGADA'),
    write('Cisterna: '), write(EstadoCisterna), write(' ('), write(NivelCisterna), write('%)'), nl,
    write('Tanque 1: '), write(EstadoTk1), write(' ('), write(NivelTk1), write('%)'), nl,
    write('Tanque 2: '), write(EstadoTk2), write(' ('), write(NivelTk2), write('%)'), nl,
    write('Bomba: '), write(EstadoBomba), nl.

cambiar_nivel_cisterna(NuevoNivel) :-
    ((NuevoNivel >= 0, NuevoNivel =< 100) ->
        retractall(nivel_agua_cisterna(_)),
        assertz(nivel_agua_cisterna(NuevoNivel)),
        actualizar_estado_cisterna,
        write('Cisterna: '), write(NuevoNivel), write('%'), nl
    ;
        write('Error.'), nl
    ).

cambiar_nivel_tanque(Tanque, NuevoNivel) :-
    ((NuevoNivel >= 0, NuevoNivel =< 100) ->
        retractall(nivel_agua_tanque(Tanque, _)),
        assertz(nivel_agua_tanque(Tanque, NuevoNivel)),
        actualizar_estado_tanque(Tanque),
        write(Tanque), write(': '), write(NuevoNivel), write('%'), nl
    ;
        write('Error.'), nl
    ).

simular_paso :-
    write('Simulando...'), nl,
    (esta_apagada ->
        nivel_agua_tanque(tk1, N1),
        NuevoN1 is max(0, N1 - 10),
        cambiar_nivel_tanque(tk1, NuevoN1),
        nivel_agua_tanque(tk2, N2),
        NuevoN2 is max(0, N2 - 10),
        cambiar_nivel_tanque(tk2, NuevoN2),
        write('Tanques -10%'), nl
    ;
        nivel_agua_tanque(tk1, N1),
        NuevoN1 is min(100, N1 + 15),
        cambiar_nivel_tanque(tk1, NuevoN1),
        nivel_agua_tanque(tk2, N2),
        NuevoN2 is min(100, N2 + 15),
        cambiar_nivel_tanque(tk2, NuevoN2),
        nivel_agua_cisterna(Nc),
        NuevoNc is max(0, Nc - 10),
        cambiar_nivel_cisterna(NuevoNc),
        write('Tanques +15%, Cisterna -10%'), nl
    ),
    actualizar_todos_estados,
    controlar_bomba.

mostrar_menu :-
    nl,
    write('1. Mostrar estado.'), nl,
    write('2. Controlar bomba.'), nl,
    write('3. Cambiar cisterna.'), nl,
    write('4. Cambiar tanque 1.'), nl,
    write('5. Cambiar tanque 2.'), nl,
    write('6. Simular paso.'), nl,
    write('7. Mostrar menu.'), nl,
    write('8. Salir.'), nl,
    write('Opcion: ').

procesar_opcion(1) :-
    mostrar_estado_actual.

procesar_opcion(2) :-
    controlar_bomba.

procesar_opcion(3) :-
    write('Nivel cisterna: '),
    read(Nivel),
    cambiar_nivel_cisterna(Nivel).

procesar_opcion(4) :-
    write('Nivel tanque 1: '),
    read(Nivel),
    cambiar_nivel_tanque(tk1, Nivel).

procesar_opcion(5) :-
    write('Nivel tanque 2: '),
    read(Nivel),
    cambiar_nivel_tanque(tk2, Nivel).

procesar_opcion(6) :-
    simular_paso.

procesar_opcion(7) :-
    mostrar_menu.

procesar_opcion(8) :-
    write('Saliendo.'), nl,
    halt.

procesar_opcion(_) :-
    write('Opcion no valida.'), nl.

iniciar_sistema :-
    mostrar_menu,
    repeat,
    read(Opcion),
    procesar_opcion(Opcion),
    (Opcion =:= 8 -> true ; mostrar_menu, fail).

ejecutar_prueba_completa :-
    write('Prueba iniciada.'), nl,
    mostrar_estado_actual, nl,
    controlar_bomba, nl,
    cambiar_nivel_tanque(tk1, 80),
    controlar_bomba, nl,
    cambiar_nivel_tanque(tk2, 96),
    controlar_bomba, nl,
    cambiar_nivel_cisterna(15),
    controlar_bomba, nl,
    cambiar_nivel_cisterna(80),
    cambiar_nivel_tanque(tk1, 20),
    cambiar_nivel_tanque(tk2, 40),
    controlar_bomba, nl,
    write('Prueba finalizada.'), nl.

:- write('Sistema listo.'), nl,
   write('Comandos: iniciar_sistema. o ejecutar_prueba_completa.'), nl.