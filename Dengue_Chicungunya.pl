% Diagnostico de Dengue y Chikungunya

comenzar :-
    write('DIAGNOSTICO DE DENGUE Y CHIKUNGUYA'), nl,
    write('Responda si o no'), nl,
    preguntas.

preguntas :-
    write('Tiene dolor de cabeza? '), read(DolorCabeza),
    write('Tiene dolores musculares, oseos o articulares? '), read(DolorMuscular),
    write('Tiene nauseas? '), read(Nauseas),
    write('Tiene vomitos? '), read(Vomitos),
    write('Tiene fiebre? '), read(Fiebre),
    write('Tiene dolor detras de los ojos? '), read(DolorOjos),
    write('Tiene glandulas inflamadas? '), read(Glandulas),
    write('Tiene sarpullido? '), read(Sarpullido),
    write('Tiene fatiga? '), read(Fatiga),
    write('Tiene erupcion cutanea? '), read(Erupcion),
    revisar(DolorCabeza, DolorMuscular, Nauseas, Vomitos, Fiebre, DolorOjos, Glandulas, Sarpullido, Fatiga, Erupcion).

revisar(DolorCabeza, DolorMuscular, Nauseas, Vomitos, Fiebre, DolorOjos, Glandulas, Sarpullido, Fatiga, Erupcion) :-
    DolorCabeza == si,
    DolorMuscular == si,
    Nauseas == si,
    Vomitos == si,
    Fiebre == si,
    DolorOjos == si,
    Glandulas == si,
    Sarpullido == si,
    write('Posible Dengue'), nl,
    write('Tratamiento:'), nl,
    write('Reposo en cama'), nl,
    write('Tomar mucho liquido'), nl,
    write('Paracetamol para la fiebre'), nl,
    write('Evitar aspirina'), nl,
    write('Ir al medico inmediatamente').

revisar(DolorCabeza, DolorMuscular, Nauseas, Vomitos, Fiebre, DolorOjos, Glandulas, Sarpullido, Fatiga, Erupcion) :-
    Fiebre == si,
    DolorMuscular == si,
    DolorCabeza == si,
    Nauseas == si,
    Fatiga == si,
    Erupcion == si,
    write('Posible Chikungunya'), nl,
    write('Tratamiento:'), nl,
    write('Reposo'), nl,
    write('Compresas frias para articulaciones'), nl,
    write('Medicamentos para el dolor'), nl,
    write('Fisioterapia suave'), nl,
    write('Consulta medica necesaria').

revisar(_, _, _, _, _, _, _, _, _, _) :-
    write('No se pudo determinar con claridad'), nl,
    write('Consulte a un medico para evaluacion').
