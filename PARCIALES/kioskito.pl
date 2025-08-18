% Parcial: Kioskito.

% 1)

atiende(dodain,horario(lunes,9,15)).
atiende(dodain,horario(miercoles,9,15)).
atiende(dodain,horario(viernes,9,15)).
atiende(lucas,horario(martes,10,20)).
atiende(juanC,horario(sabado,18,22)).
atiende(juanC,horario(domingo,18,22)).
atiende(juanFds,horario(jueves,10,20)).
atiende(juanFds,horario(viernes,12,20)).
atiende(leoC,horario(lunes,14,18)).
atiende(leoC,horario(miercoles,14,18)).
atiende(martu,horario(miercoles,23,24)).
atiende(vale,Horario):-
    atiende(dodain,Horario).
atiende(vale,Horario):-
    atiende(juanC,Horario).

% 2)

quienAtiende(Dia,Hora,Persona):-
    atiende(Persona,horario(Dia,HoraInicial,HoraFinal)),
    between(HoraInicial,HoraFinal,Hora). 

% 3)

foreverAlone(Persona,Dia,Hora):-
    quienAtiende(Dia,Hora,Persona),
    not((quienAtiende(Dia,Hora,OtraPersona), OtraPersona \= Persona)).

% 4)

venta(dodain,fecha(lunes,10,agosto),[golosinas(1200),cigarrillo([malrboro]),golosinas(50)]).
venta(dodain,fecha(miercoles,12,agosto),[bebidas(alcoholica,8),bebidas(noAlcoholicas,1),golosinas(10)]).
venta(martu,fecha(miercoles,12,agosto),[golosinas(1000),cigarrillos([chesterfield,colorado,parisiennes])]).
venta(lucas,fecha(martes,11,agosto),[golosinas(600)]).
venta(lucas,fecha(martes,18,agosto),[bebidas(noAlcoholica,2),cigarrillos([derby])]).

esImportante(golosinas(Precio)):-
    Precio > 100.

esImportante(cigarrillos([Lista])):-
    length(Lista,Cantidad),
    Cantidad > 2.

esImportante(bebidas(alcoholica,_)).

esImportante(bebidas(_,Cantidad)):-
    Cantidad > 5.

esSuertuda(Persona):-
    venta(Persona,_,_),
    forall(venta(Persona,Dia,_),(primerVenta(Persona,Dia,Venta),esImportante(Venta))).

primerVenta(Persona,Dia,Venta):-
    venta(Persona,Dia,ListaDeVentas),
    nth1(1,ListaDeVentas,Venta).

/* SOLUCION ALTERNATIVA:

ventaRealizada(dodain,fecha(lunes,10,agosto),golosinas(1200)).
ventaRealizada(dodain,fecha(lunes,10,agosto),cigarrillos([jockey])).
ventaRealizada(dodain,fecha(lunes,10,agosto),golosinas(50)).
ventaRealizada(dodain,fecha(miercoles,12,agosto),bebidas(alcoholica,8)).
ventaRealizada(dodain,fecha(miercoles,12,agosto),bebidas(noAlcoholica,1)).
ventaRealizada(dodain,fecha(miercoles,12,agosto),golosinas(10)).
ventaRealizada(martu,fecha(miercoles,12,agosto),golosinas(1000)).
ventaRealizada(martu,fecha(miercoles,12,agosto),cigarrillos([chesterfield,colorado,parisiennes])).
ventaRealizada(lucas,fecha(martes,11,agosto),golosinas(600)).
ventaRealizada(lucas,fecha(martes,18,agosto),bebidas(noAlcoholica,2)).
ventaRealizada(lucas,fecha(martes,18,agosto),cigarrillos([derby])).

esSuertuda(Persona):-
    ventaRealizada(Persona,_,_),
    forall(ventaRealizada(Persona,Dia,_),(primerVenta(Persona,Dia,Venta),ventaImportante(Venta))).

primerVenta(Persona,Dia,Venta):-
    findall(Venta,ventaRealizada(Persona,Dia,Venta),ListaDeVentas),
    nth1(1,ListaDeVentas,Venta).

ventaImportante(golosinas(Precio)):-
    Precio > 100.

ventaImportante(cigarrillos(Marcas)):-
    length(Marcas,Cantidad),
    Cantidad > 2.

ventaImportante(bebidas(alcoholica,_)).

ventaImportante(bebidas(_,Cantidad)):-
    Cantidad > 5. */








