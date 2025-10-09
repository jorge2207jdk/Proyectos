:- use_module(library(lists)).

% Sintomas asociados a enfermedades comunes
sintoma(fiebre).
sintoma(dolor_cabeza).
sintoma(dolor_garganta).
sintoma(congestion_nasal).
sintoma(tos).
sintoma(dolor_muscular).
sintoma(diarrea).
sintoma(vomitos).
sintoma(erupcion_cutanea).
sintoma(ojos_rojos).
sintoma(perdida_apetito).
sintoma(piel_amarilla).
sintoma(dolor_abdominal).
sintoma(dolor_detras_ojos).
sintoma(sangrado_leve).
sintoma(dolor_articulaciones).
sintoma(dolor_lumbar).

% Relación entre enfermedades y sus síntomas
sintomas_de(gripe, [fiebre, dolor_cabeza, dolor_muscular, tos]).
sintomas_de(resfriado_comun, [congestion_nasal, dolor_garganta, tos]).
sintomas_de(dengue, [fiebre, dolor_muscular, dolor_cabeza, erupcion_cutanea, dolor_detras_ojos, sangrado_leve]).
sintomas_de(gastroenteritis, [diarrea, vomitos, dolor_abdominal]).
sintomas_de(conjuntivitis, [ojos_rojos]).
sintomas_de(hepatitis_a, [fiebre, perdida_apetito, vomitos, piel_amarilla, dolor_abdominal]).
sintomas_de(virus_oropouche, [fiebre, dolor_cabeza, dolor_muscular, dolor_articulaciones, dolor_lumbar, vomitos]).
sintomas_de(zika, [fiebre, erupcion_cutanea, dolor_articulaciones, ojos_rojos]).
sintomas_de(typhoid, [fiebre, dolor_abdominal, dolor_cabeza, diarrea]).

medicamento(paracetamol, gripe, 15).
medicamento(ibuprofeno, gripe, 10).
medicamento(vitamina_c, resfriado_comun, 20).
medicamento(suero_oral, gastroenteritis, 25).
medicamento(loratadina, resfriado_comun, 5).
medicamento(colirio, conjuntivitis, 8).
medicamento(suero_oral, dengue, 15).
medicamento(paracetamol, dengue, 12).
medicamento(carevit, hepatitis_a, 8).
medicamento(paracetamol, virus_oropouche, 10).

% Enfermedades que requieren manejo hospitalario
requiere_hospitalizacion(dengue_severo).
requiere_hospitalizacion(hepatitis_a_fulminante).


% Regla para diagnosticar una enfermedad basada en síntomas
diagnosticar(Enfermedad, SintomasPaciente) :-
    sintomas_de(Enfermedad, SintomasEnfermedad),
    subset(SintomasEnfermedad, SintomasPaciente).

% Regla para verificar tratamiento disponible
tratamiento_disponible(Enfermedad, Medicamento, Cantidad) :-
    medicamento(Medicamento, Enfermedad, Cantidad),
    Cantidad > 0.

% Regla principal: diagnóstico con tratamiento
diagnostico_completo(Paciente, Enfermedad, Medicamento, Cantidad) :-
    diagnosticar(Enfermedad, Paciente),
    tratamiento_disponible(Enfermedad, Medicamento, Cantidad).

% Regla para enfermedades que requieren referencia hospitalaria - CORREGIDA
referencia_hospitalaria(Enfermedad) :-
    diagnosticar(Enfermedad, _),
    (Enfermedad = dengue; Enfermedad = hepatitis_a),
    write('ADVERTENCIA: '), write(Enfermedad), 
    write(' requiere evaluación hospitalaria inmediata'), nl.

% Regla mejorada para enfermedades emergentes recientes
enfermedad_emergente(virus_oropouche).
enfermedad_emergente(dengue).
enfermedad_emergente(zika).

% Consulta para ver todas las enfermedades emergentes
enfermedades_emergentes_cuba(ListaEmergentes) :-
    findall(Enfermedad, enfermedad_emergente(Enfermedad), ListaEmergentes).


% Regla para mostrar todos los tratamientos disponibles para una enfermedad
tratamientos_para_enfermedad(Enfermedad) :-
    findall(medicamento(Med, Cant), 
            (medicamento(Med, Enfermedad, Cant), Cant > 0), 
            Tratamientos),
    length(Tratamientos, NumTratamientos),
    (NumTratamientos > 0 ->
        write('Tratamientos disponibles para '), write(Enfermedad), write(':'), nl,
        forall(member(medicamento(Med, Cant), Tratamientos),
               (write('- '), write(Med), write(' (Cantidad: '), write(Cant), write(')'), nl))
    ;
        write('No hay tratamientos disponibles para '), write(Enfermedad), nl
    ).

% Regla para verificar síntomas específicos de un paciente
analizar_sintomas(SintomasPaciente) :-
    findall(Enf, diagnosticar(Enf, SintomasPaciente), Enfermedades),
    (Enfermedades = [] ->
        write('No se pudo diagnosticar ninguna enfermedad con los síntomas proporcionados'), nl
    ;
        write('Enfermedades posibles: '), write(Enfermedades), nl,
        forall(member(Enf, Enfermedades), 
               (write('---'), nl,
                write('Enfermedad: '), write(Enf), nl,
                tratamientos_para_enfermedad(Enf),
                (member(Enf, [dengue, hepatitis_a]) ->
                    referencia_hospitalaria(Enf)
                ;
                    true
                ),
                nl))
    ).

% Regla para obtener inventario completo
mostrar_inventario_completo :-
    findall(medicamento(Med, Enf, Cant), medicamento(Med, Enf, Cant), Medicamentos),
    write('INVENTARIO COMPLETO'), nl,
    forall(member(medicamento(Med, Enf, Cant), Medicamentos),
           (write('- '), write(Med), write(' para '), write(Enf), 
            write(' (Stock: '), write(Cant), write(')'), nl)).


% Ejemplo 1: Diagnosticar un caso sospechoso de dengue
consulta_ejemplo_dengue :-
    write('CONSULTA EJEMPLO: DENGUE'), nl,
    analizar_sintomas([fiebre, dolor_cabeza, dolor_muscular, erupcion_cutanea]).

% Ejemplo 2: Verificar enfermedades emergentes
consulta_emergentes :-
    enfermedades_emergentes_cuba(Emergentes),
    write('Enfermedades emergentes en Cuba: '), write(Emergentes), nl.

% Ejemplo 3: Consultar inventario completo
consulta_inventario :-
    mostrar_inventario_completo.

% Ejemplo 4: Caso de gripe
consulta_ejemplo_gripe :-
    write('CONSULTA EJEMPLO: GRIPE'), nl,
    analizar_sintomas([fiebre, dolor_cabeza, tos]).


iniciar_sistema :-
    write('================================'), nl,
    write('  SISTEMA EXPERTO MÉDICO'), nl,
    write('================================'), nl, nl,
    write('Consultas predefinidas disponibles:'), nl,
    write('1. consulta_ejemplo_dengue'), nl,
    write('2. consulta_ejemplo_gripe'), nl,
    write('3. consulta_emergentes'), nl,
    write('4. consulta_inventario'), nl,
    write('5. analizar_sintomas([sintoma1, sintoma2, ...])'), nl,
    write('6. diagnostico_completo([sintomas], Enf, Med, Cant)'), nl,
    write('7. tratamientos_para_enfermedad(Enfermedad)'), nl, nl,
    write('Síntomas disponibles:'), nl,
    findall(S, sintoma(S), Sintomas),
    write(Sintomas), nl, nl.