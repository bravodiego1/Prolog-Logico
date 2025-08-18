% Parcial: Afirmativo

% BASE DE CONOCIMIENTO:

%tarea(agente, tarea, ubicacion)
%tareas:
%  ingerir(descripcion, tamaño, cantidad)
%  apresar(malviviente, recompensa)
%  asuntosInternos(agenteInvestigado)
%  vigilar(listaDeNegocios)

tarea(vigilanteDelBarrio, ingerir(pizza, 1.5, 2),laBoca).
tarea(vigilanteDelBarrio, vigilar([pizzeria, heladeria]), barracas).
tarea(canaBoton, asuntosInternos(vigilanteDelBarrio), barracas).
tarea(sargentoGarcia, vigilar([pulperia, haciendaDeLaVega, plaza]),puebloDeLosAngeles).
tarea(sargentoGarcia, ingerir(vino, 0.5, 5),puebloDeLosAngeles).
tarea(sargentoGarcia, apresar(elzorro, 100), puebloDeLosAngeles). 
tarea(vega, apresar(neneCarrizo,50),avellaneda).
tarea(jefeSupremo, vigilar([congreso,casaRosada,tribunales]),laBoca).

% Las ubicaciones que existen son las siguientes:
ubicacion(puebloDeLosAngeles).
ubicacion(avellaneda).
ubicacion(barracas).
ubicacion(marDelPlata).
ubicacion(laBoca).
ubicacion(uqbar).
ubicacion(quilmes).
ubicacion(buenosAires).

% Por último, se sabe quién es jefe de quién:
% jefe(jefe, subordinado)
jefe(jefeSupremo,vega ).
jefe(vega, vigilanteDelBarrio).
jefe(vega, canaBoton).
jefe(jefeSupremo,sargentoGarcia).

% 1) Hacer el predicado frecuenta/2 que relaciona un agente con una ubicación en la que suele estar. Debe ser inversible. 
% Los agentes frecuentan las ubicaciones en las que realizan tareas
% Todos los agentes frecuentan buenos aires.
% Vega frecuenta quilmes.
% Si un agente tiene como tarea vigilar un negocio de alfajores, frecuenta Mar del Plata.

frecuenta(Agente,Ubicacion):-
    tarea(Agente,_,_),
    ubicacion(Ubicacion),
    sueleEstarEn(Agente,Ubicacion).

sueleEstarEn(Agente,Ubicacion):-
    tarea(Agente,_,Ubicacion).

sueleEstarEn(Agente,buenosAires):-
    tarea(Agente,_,_).

sueleEstarEn(vega,quilmes).

sueleEstarEn(Agente,marDelPlata):-
    tarea(Agente,vigilar(Negocios),_),
    member(alfajoreria,Negocios).

% 2) Hacer el predicado que permita averiguar algún lugar inaccesible, es decir, al que nadie frecuenta. 

lugarInaccesible(Lugar):-
    ubicacion(Lugar),
    not(frecuenta(_,Lugar)).


% 3) Hacer el predicado afincado/1, que permite deducir si un agente siempre realiza sus tareas en la misma ubicación. 

afincado(Agente):-
    tarea(Agente,_,Ubicacion),
    not((tarea(Agente,_,OtraUbicacion), Ubicacion \= OtraUbicacion)).

% 4) Hacer un predicado llamado agentePremiado/1 que permite deducir el agente que recibe el premio por tener la mejor puntuación. 
% La puntuación de un agente es la sumatoria de los puntos de cada tarea que el agente realiza, que puede ser positiva o negativa. Se calcula de la siguiente manera:
% vigilar: 5 puntos por cada negocio que vigila
% ingerir: 10 puntos negativos por cada unidad de lo que ingiera. Las unidades ingeridas se calculan como tamaño x cantidad.
% apresar: tantos puntos como la mitad de la recompensa.
% asuntosInternos: el doble de la puntuación del agente al que investiga.

agentePremiado(Agente):-
    tarea(Agente,_,_),
    puntuacionTotalTareas(Agente,Total),
    not((tarea(OtroAgente,_,_),puntuacionTotalTareas(OtroAgente,OtroTotal), OtroTotal > Total)).

puntuacionTotalTareas(Agente,Total):-
    findall(Cantidad,(tarea(Agente,Tarea,_), puntuacionSegunTarea(Tarea,Cantidad)),CantidadTotal),
    sumlist(CantidadTotal,Total).

puntuacionSegunTarea(vigilar(Negocios),Total):-
    length(Negocios,NegociosVigilados),
    Total is NegociosVigilados * 5.

puntuacionSegunTarea(ingerir(_,Tamanio,Cantidad),Total):-
    Total is (Tamanio * Cantidad) * (-10).

puntuacionSegunTarea(apresar(_,Recompensa),Total):-
    Total is Recompensa / 2.

puntuacionSegunTarea(asuntosInternos(AgenteInvestigado),Total):- 
    puntuacionTotalTareas(AgenteInvestigado, PuntajeInvestigado),
    Total is PuntajeInvestigado * 2.











