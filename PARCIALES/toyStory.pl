% Parcial: Toy Story

% BASE DE CONOCIMIENTO:

% Relaciona al dueño con el nombre del juguete y la cantidad de años que lo ha tenido.

duenio(andy, woody, 8).
duenio(andy,buzz,9).
duenio(sam, jessie, 3).
duenio(sam, woody, 6).
duenio(andy, barbie, 5).
duenio(ana, soldados, 1).
duenio(ana, seniorCaraDePapa, 4).

% Relaciona al juguete con su nombre. Los juguetes son de la forma:
% deTrapo(tematica)
% deAccion(tematica, partes)
% miniFiguras(tematica, cantidadDeFiguras)
% caraDePapa(partes)

juguete(woody, deTrapo(vaquero)).
juguete(jessie, deTrapo(vaquero)).
juguete(buzz, deAccion(espacial,[original(casco)])).
juguete(barbie,deAccion(stacyMalibu,[sombrero])).
juguete(soldados, miniFiguras(soldado, 60)).
juguete(monitosEnBarril, miniFiguras(mono, 50)).
juguete(seniorCaraDePapa,caraDePapa([original(pieIzquierdo),original(pieDerecho),repuesto(nariz)])).

% Dice si un juguete es raro

esRaro(deAccion(stacyMalibu,[sombrero])).

% Dice si una persona es coleccionista

esColeccionista(sam).

% 1. a. tematica/2: relaciona a un juguete con su temática. La temática de los cara de papa es caraDePapa.

tematica(Juguete,Tematica):-
    juguete(_,Juguete),
    tematicaDelJuguete(Juguete,Tematica).

tematicaDelJuguete(deTrapo(Tematica),Tematica).

tematicaDelJuguete(deAccion(Tematica,_),Tematica).

tematicaDelJuguete(miniFiguras(Tematica,_),Tematica).

tematicaDelJuguete(caraDePapa(_),caraDePapa).

% 1. b. esDePlastico/1: Nos dice si el juguete es de plástico, lo cual es verdadero sólo para las miniFiguras y los caraDePapa.

esDePlastico(Juguete):-
    juguete(_,Juguete),
    cumpleCondicionPlastico(Juguete).

cumpleCondicionPlastico(miniFiguras(_,_)).

cumpleCondicionPlastico(caraDePapa(_)).

% 1. c. esDeColeccion/1:Tanto lo muñecos de acción como los cara de papa son de colección si son raros, los de trapo siempre 
% lo son, y las mini figuras, nunca.

esDeColeccion(Juguete):-
    juguete(_,Juguete),
    cumpleCondicionColeccionable(Juguete).

cumpleCondicionColeccionable(deTrapo(_)).

cumpleCondicionColeccionable(deAccion(Tematica,Partes)):-
    esRaro(deAccion(Tematica,Partes)).

cumpleCondicionColeccionable(caraDePapa(Partes)):-
    esRaro(caraDePapa(Partes)).

% 2. amigoFiel/2: Relaciona a un dueño con el nombre del juguete que no sea de plástico que tiene hace
%  más tiempo. Debe ser completamente inversible.

amigoFiel(Duenio,NombreJuguete):-
    duenio(Duenio,NombreJuguete,TiempoQueLoTiene),
    juguete(NombreJuguete,Juguete),
    not(esDePlastico(Juguete)),
    not((duenio(Duenio,OtroNombre,OtroTiempoQueLoTiene), NombreJuguete \= OtroNombre, OtroTiempoQueLoTiene > TiempoQueLoTiene)).

% OPCION ALTERNATIVA:

/* amigoFiel2(Duenio,NombreJuguete):-
    duenio(Duenio,NombreJuguete,_),
    juguete(NombreJuguete,Juguete),
    not(esMasAntiguoQue2(Duenio,NombreJuguete,_)),
    not(esDePlastico(Juguete)).

esMasAntiguoQue2(Duenio,NombreJuguete,OtroNombreJuguete):-
    duenio(Duenio,NombreJuguete,TiempoQueLoTiene),
    duenio(Duenio,OtroNombreJuguete,OtroTiempoQueLoTiene),
    NombreJuguete \= OtroNombreJuguete,
    OtroTiempoQueLoTiene > TiempoQueLoTiene.  */

% 3. superValioso/1: Genera los nombres de juguetes de colección que tengan todas sus piezas originales, y que
% no estén en posesión de un coleccionista.

esDeColeccionYPorPartes(Juguete):-
    esDeColeccion(Juguete),
    Juguete \= deTrapo(_).

tieneTodasSusPiezasOriginales(deAccion(_,Partes)):-
    not(member(repuesto(_),Partes)).

tieneTodasSusPiezasOriginales(caraDePapa(Partes)):-
    not(member(repuesto(_),Partes)).

noEstaEnPosesionDeColeccionista(Juguete):-
    juguete(NombreJuguete,Juguete),
    duenio(Duenio,NombreJuguete,_),
    not(esColeccionista(Duenio)).

cumpleCondicionesDeValor(Juguete):-
    esDeColeccionYPorPartes(Juguete),
    tieneTodasSusPiezasOriginales(Juguete),
    noEstaEnPosesionDeColeccionista(Juguete).

superValioso(ListaDeJuguetes):-
    findall(Juguete, cumpleCondicionesDeValor(Juguete), ListaDeJuguetes). 

% 4. dúoDinámico/3: Relaciona un dueño y a dos nombres de juguetes que le pertenezcan que
% hagan buena pareja. Dos juguetes distintos hacen buena pareja si son de la misma temática.
% Además woody y buzz hacen buena pareja. Debe ser complemenente inversible.

pertenecenA(Duenio,NombreJuguete1,NombreJuguete2):-
    duenio(Duenio,NombreJuguete1,_),
    duenio(Duenio,NombreJuguete2,_),
    NombreJuguete1 \= NombreJuguete2.

sonDeLaMismaTematica(Juguete,OtroJuguete):-
    tematica(Juguete,Tematica),
    tematica(OtroJuguete,Tematica).

cumplenCondicionesDeDupla(Duenio,NombreJuguete1,NombreJuguete2):-
    pertenecenA(Duenio,NombreJuguete1,NombreJuguete2),
    juguete(NombreJuguete1,Juguete1),
    juguete(NombreJuguete2,Juguete2),
    sonDeLaMismaTematica(Juguete1,Juguete2).

cumplenCondicionesDeDupla(Duenio,woody,buzz):-
    pertenecenA(Duenio,woody,buzz).

duoDinamico(Duenio,NombreJuguete1,NombreJuguete2):-
    cumplenCondicionesDeDupla(Duenio,NombreJuguete1,NombreJuguete2).

% felicidad/2:Relaciona un dueño con la cantidad de felicidad que le otorgan todos sus juguetes:
% ● las minifiguras le dan a cualquier dueño 20 * la cantidad de figuras del conjunto
% ● los cara de papas dan tanta felicidad según que piezas tenga: las originales dan 5, las de repuesto,8.
% ● los de trapo, dan 100
% ● Los de accion, dan 120 si son de coleccion y el dueño es coleccionista. Si no dan lo mismo que los de trapo.
% Debe ser completamente inversible.

felicidad(Duenio,Cantidad):-
    duenio(Duenio,_,_),
    findall(Felicidad,felicidadJugueteDe(Duenio,_,Felicidad),FelicidadTotal),
    sumlist(FelicidadTotal,Cantidad).

felicidadJugueteDe(Duenio,NombreJuguete,Felicidad):-
    duenio(Duenio,NombreJuguete,_),
    juguete(NombreJuguete,Juguete),
    felicidadPorJugueteDe(Duenio,Juguete,Felicidad).

felicidadPorJugueteDe(_,miniFiguras(_,CantidadDeFiguras),Felicidad):-
    Felicidad is 20 * CantidadDeFiguras.

felicidadPorJugueteDe(_,deTrapo(_),100).

felicidadPorJugueteDe(Duenio,deAccion(Tematica,Partes),120):-
    esDeColeccion(deAccion(Tematica,Partes)),
    esColeccionista(Duenio).

felicidadPorJugueteDe(Duenio,deAccion(Tematica,Partes),100):-
    not((esDeColeccion(deAccion(Tematica,Partes)), esColeccionista(Duenio))).

felicidadPorJugueteDe(_,caraDePapa(Piezas),Felicidad):-
    findall(Valor,(member(Pieza,Piezas), valorPieza(Pieza,Valor)),Valores),
    sumlist(Valores,Felicidad).
 
valorPieza(original(_),5).

valorPieza(repuesto(_),8).

% 6. puedeJugarCon/2: Relaciona a alguien con un nombre de juguete cuando puede jugar con él.
% Esto ocurre cuando:
% ● este alguien es el dueño del juguete
% ● o bien, cuando exista otro que pueda jugar con este juguete y pueda prestárselo
% Alguien puede prestarle un juguete a otro cuando es dueño de una mayor cantidad de juguetes.

puedeJugarCon(Persona,NombreJuguete):-
    duenio(Persona,NombreJuguete,_).

puedeJugarCon(Persona,NombreJuguete):-
    duenio(Persona,_,_),
    duenio(OtraPersona,NombreJuguete,_),
    Persona \= OtraPersona,
    puedePrestarJuguete(OtraPersona,Persona). 

puedePrestarJuguete(Persona,OtraPersona):-
    cantidadDeJuguetesPorPersona(Persona,Cantidad1),
    cantidadDeJuguetesPorPersona(OtraPersona,Cantidad2),
    Cantidad1 > Cantidad2.

cantidadDeJuguetesPorPersona(Persona,Cantidad):-
    findall(Juguete,duenio(Persona,Juguete,_),ListaDeJuguetes),
    length(ListaDeJuguetes,Cantidad).

% 7. podriaDonar/3: relaciona a un dueño, una lista de juguetes propios y una cantidad de felicidad cuando entre 
% todos los juguetes de la lista le generan menos que esa cantidad de felicidad. Debe ser completamente inversible.

podriaDonar(Duenio, JuguetesPropios, CantidadDeFelicidad):-
    duenio(Duenio, _, _),
    todosSonPropios(Duenio, JuguetesPropios),
    findall(Felicidad,(member(NombreJuguete, JuguetesPropios),juguete(NombreJuguete, JugueteTerm),felicidadPorJugueteDe(Duenio, JugueteTerm, Felicidad)),ListaFelicidad),
    sumlist(ListaFelicidad, TotalFelicidad),
    TotalFelicidad < CantidadDeFelicidad.

todosSonPropios(_, []).

todosSonPropios(Duenio, [NombreJuguete|Resto]):-
    duenio(Duenio, NombreJuguete, _),
    todosSonPropios(Duenio, Resto).














   







    






