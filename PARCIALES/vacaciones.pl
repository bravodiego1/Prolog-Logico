% Parcial: Vacaciones

% 1)

seVaA(dodain,pehuenia).
seVaA(dodain,sanMartinDeLosAndes).
seVaA(dodain,esquel).
seVaA(dodain,sarmiento).
seVaA(dodain,camarones).
seVaA(dodain,playasDoradas).
seVaA(alf,bariloche).
seVaA(alf,sanMartinDeLosAndes).
seVaA(alf,elBolson).
seVaA(nico,marDelPlata).
seVaA(vale,calafate).
seVaA(vale,elBolson).

seVaA(martu,Lugar):-
    seVaA(nico,Lugar).
seVaA(martu,Lugar):-
    seVaA(alf,Lugar).

% 2) 

atraccionesDe(esquel,parqueNacional(losAlerces)).
atraccionesDe(esquel,excursion([t,r,o,c,h,i,t,a])).
atraccionesDe(esquel,excursion([t,r,e,v,e,l,i,n])).
atraccionesDe(pehuenia,cerro(bateaMahuida,2000)).  
atraccionesDe(pehuenia,cuerpoAgua(puedePescar,14)).
atraccionesDe(pehuenia,cuerpoAgua(puedePescar,19)).
atraccionesDe(playasDoradas,playa(3)).

tuvoCopadasVacaciones(Persona):-
    seVaA(Persona,_),
    forall(seVaA(Persona,Lugar),tieneAtraccionCopada(Lugar)). % PARA TODO LUGAR AL QUE VA UNA PERSONA, TIENE (AL MENOS) UNA ATRACCION COPADA.

tieneAtraccionCopada(Lugar):-
    atraccionesDe(Lugar,Atraccion),
    esCopada(Atraccion).

esCopada(cerro(_,Altura)):-
    Altura > 2000.

esCopada(cuerpoAgua(puedePescar,Temperatura)):-
    Temperatura > 20.

esCopada(playa(DiferenciaMareas)):-
    DiferenciaMareas < 5.

esCopada(excursion(Nombre)):-
    length(Nombre,Letras),
    Letras > 7.

esCopada(parqueNacional(_)). 

% 3)

noSeCruzaron(Persona,OtraPersona):-
    seVaA(Persona,_),
    seVaA(OtraPersona,_),
    not((seVaA(Persona,Lugar),seVaA(OtraPersona,Lugar))),
    Persona \= OtraPersona.

% 4) 

costoDeVida(sarmiento,100).
costoDeVida(esquel,150).
costoDeVida(pehuenia,180).
costoDeVida(sanMartinDeLosAndes,150).
costoDeVida(camarones,135).
costoDeVida(playasDoradas,170).
costoDeVida(bariloche,140).
costoDeVida(calafate,240).
costoDeVida(elBolson,145).
costoDeVida(marDelPlata,140).

tuvoVacacionesGasoleras(Persona):-
    seVaA(Persona,_),
    forall(seVaA(Persona,Lugar),(costoDeVida(Lugar,Costo),Costo < 160)).
    
% 5) 

destinosPosibles(Persona, DestinosPosibles):-
    findall(Lugar, seVaA(Persona, Lugar), Destinos),
    permutarDestinos(Destinos, DestinosPosibles).

permutarDestinos([], []).
permutarDestinos(Destinos, [Primero|Resto]) :-
    seleccionar(Primero, Destinos, RestoDestinos),
    permutarDestinos(RestoDestinos, Resto).

seleccionar(Elemento, [Elemento|Resto], Resto).
seleccionar(Elemento, [Otro|Resto], [Otro|RestoSeleccionado]) :-
    seleccionar(Elemento, Resto, RestoSeleccionado). 