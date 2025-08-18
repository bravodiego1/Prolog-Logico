% Parcial: Sueños.

% 1)

cree(gabriel,campanita).
cree(gabriel,magoDeOz).
cree(gabriel,cavenaghi).
cree(juan,conejoDePascua).
cree(macarena,reyesMagos).
cree(macarena,magoCapria).
cree(macarena,campanita).

suenio(gabriel,loteria([5,9])).
suenio(gabriel,futbolista(arsenal)).
suenio(juan,cantante(100000)).
suenio(macarena,cantante(10000)).

% 2)

esAmbiciosa(Persona):-
    cree(Persona,_),
    sumatoriaDificultadSuenios(Persona,Total),
    Total > 20.

sumatoriaDificultadSuenios(Persona,Total):-
    findall(Dificultad,(suenio(Persona,Suenio),dificultadPorSuenio(Suenio,Dificultad)),ListaDeDificultades),
    sumlist(ListaDeDificultades,Total).

dificultadPorSuenio(cantante(Discos),6):-
    Discos > 500000.

dificultadPorSuenio(cantante(Discos),4):-
    between(0,500000,Discos).

dificultadPorSuenio(loteria(Numeros),Dificultad):-
    length(Numeros,Cantidad),
    Dificultad is Cantidad * 10.

dificultadPorSuenio(futbolista(Equipo),3):-
    esEquipoChico(Equipo).

dificultadPorSuenio(futbolista(Equipo),16):-
    not(esEquipoChico(Equipo)).

esEquipoChico(arsenal).
esEquipoChico(aldosivi).
esEquipoChico(river).

% 3) 

tienenQuimica(Personaje,Persona):-
    cree(Persona,Personaje),
    condicionDeQuimica(Persona,Personaje).

condicionDeQuimica(Persona,campanita):-
    suenio(Persona,Suenio),
    dificultadPorSuenio(Suenio,Dificultad),
    Dificultad > 5.

condicionDeQuimica(Persona,_):-
    forall(suenio(Persona,Suenio),esPuro(Suenio)),
    not(esAmbiciosa(Persona)).

esPuro(futbolista(_)).
esPuro(cantante(Discos)):-
    between(0,200000,Discos).

% 4)

esAmigo(campanita,reyesMagos).
esAmigo(campanita,conejoDePascua).
esAmigo(conejoDePascua,cavenaghi).

estaEnfermo(campanita).
estaEnfermo(reyesMagos).
estaEnfermo(conejoDePascua).

puedeAlegrar(Personaje,Persona):-
    suenio(Persona,_),
    tienenQuimica(Personaje,Persona),
    esCapazDeAlegrar(Personaje).

esCapazDeAlegrar(Personaje):-
    not(estaEnfermo(Personaje)).

esCapazDeAlegrar(Personaje):-
    personajeDeBackUp(Personaje,PersonajeDeBackUp),
    not(estaEnfermo(PersonajeDeBackUp)).

personajeDeBackUp(Personaje,PersonajeDeBackUp):-
    esAmigo(Personaje,PersonajeDeBackUp).

personajeDeBackUp(Personaje,PersonajeDeBackUp):-
    esAmigo(Personaje,Otro),
    personajeDeBackUp(Otro,PersonajeDeBackUp).






