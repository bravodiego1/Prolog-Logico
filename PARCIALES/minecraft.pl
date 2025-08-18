% Parcial: Minecraft

% BASE DE CONOCIMIENTO: 

jugador(stuart, [piedra, piedra, piedra, piedra, piedra, piedra, piedra, piedra], 3).
jugador(tim, [madera, madera, madera, madera, madera, pan, carbon, carbon, carbon, pollo, pollo], 8).
jugador(steve, [madera, carbon, carbon, diamante, panceta, panceta, panceta], 2).

lugar(playa, [stuart, tim], 2).
lugar(mina, [steve], 8).
lugar(bosque, [], 6).

comestible(pan).
comestible(panceta).
comestible(pollo).
comestible(pescado).

% 1) Jugando con los ítems:
% a. Relacionar un jugador con un ítem que posee. tieneItem/2

tieneItem(Jugador,Item):-
    jugador(Jugador,Items,_),
    member(Item,Items).

% b. Saber si un jugador se preocupa por su salud, esto es si tiene entre sus ítems más de un tipo de comestible.
% (Tratar de resolver sin findall) sePreocupaPorSuSalud/1

sePreocupaPorSuSalud(Jugador):-
    jugador(Jugador,Items,_),
    tieneMasDeUnComestible(Items).
    
tieneMasDeUnComestible(Items):-
    member(Item,Items),
    member(OtroItem,Items),
    OtroItem \= Item,
    comestible(Item),
    comestible(OtroItem).

% c. Relacionar un jugador con un ítem que existe (un ítem existe si lo tiene alguien), y la cantidad que tiene de ese ítem.
% Si no posee el ítem, la cantidad es 0. cantidadDeItem/3

cantidadDeItem(Jugador,Item,Cantidad):-
    jugador(Jugador,Items,_),
    member(Item,Items),
    findall(Item,member(Item,Items),ListaDeItemBuscado),
    length(ListaDeItemBuscado,Cantidad).

cantidadDeItem(Jugador,Item,0):-
    jugador(Jugador,ItemsDeJugador,_),
    jugador(_,ItemsPosibles,_),
    member(Item,ItemsPosibles),
    not(member(Item,ItemsDeJugador)).


% d. Relacionar un jugador con un ítem, si de entre todos los jugadores, es el que más cantidad tiene de ese ítem. tieneMasDe/2
% ?- tieneMasDe(steve, panceta).
% true.

tieneMasDe(Jugador,Item):-
    jugador(Jugador,Items,_),
    member(Item,Items),
    cantidadDeItem(Jugador,Item,Cantidad),
    not((jugador(OtroJugador,OtrosItems,_),member(Item,OtrosItems),cantidadDeItem(OtroJugador,Item,OtraCantidad),OtraCantidad > Cantidad)).


% 2) Alejarse de la oscuridad 
% a. Obtener los lugares en los que hay monstruos. Se sabe que los monstruos aparecen en los lugares cuyo nivel
% de oscuridad es más de 6. hayMonstruos/1

hayMonstruos(NombreLugar):-
    lugar(NombreLugar,_,NivelDeOscuridad),
    NivelDeOscuridad > 6.

% b. Saber si un jugador corre peligro. Un jugador corre peligro si se encuentra en un lugar donde hay monstruos; o si está
% hambriento (hambre < 4) y no cuenta con ítems comestibles. correPeligro/1

correPeligro(Jugador):-
    jugador(Jugador,_,_),
    cumpleCondicionesDePeligro(Jugador).

cumpleCondicionesDePeligro(Jugador):-
    lugar(NombreLugar,JugadoresDelLugar,_),
    hayMonstruos(NombreLugar),
    member(Jugador,JugadoresDelLugar).

cumpleCondicionesDePeligro(Jugador):-
    tieneHambre(Jugador),
    not((tieneItem(Jugador,Item),comestible(Item))).

tieneHambre(Jugador):-
    jugador(Jugador,_,NivelDeHambre),
    NivelDeHambre < 4.

% c. Obtener el nivel de peligrosidad de un lugar, el cual es un número de 0 a 100 y se calcula:
% - Si no hay monstruos, es el porcentaje de hambrientos sobre su población total.
% - Si hay monstruos, es 100.
% - Si el lugar no está poblado, sin importar la presencia de monstruos, es su nivel de oscuridad * 10. nivelPeligrosidad/2

% ?- nivelPeligrosidad(playa,Peligrosidad).
% Peligrosidad = 50.

nivelDePeligrosidad(NombreLugar,Peligrosidad):-
    lugar(NombreLugar,JugadoresDelLugar,NivelDeOscuridad),
    peligrosidadSegunLugar(NombreLugar,JugadoresDelLugar,NivelDeOscuridad,Peligrosidad).

peligrosidadSegunLugar(_,[],NivelDeOscuridad,Peligrosidad):-
    Peligrosidad is NivelDeOscuridad * 10.

peligrosidadSegunLugar(NombreLugar,JugadoresDelLugar,_,Peligrosidad):-
    not(hayMonstruos(NombreLugar)),
    findall(Jugador,(member(Jugador,JugadoresDelLugar),tieneHambre(Jugador)),JugadoresHambrientosDelLugar),
    length(JugadoresHambrientosDelLugar,CantidadDeHambrientos),
    length(JugadoresDelLugar,PoblacionTotal),
    Peligrosidad is (CantidadDeHambrientos * 100) / PoblacionTotal.

peligrosidadSegunLugar(NombreLugar,_,_,100):-
    hayMonstruos(NombreLugar).

% 3) A construir
% El aspecto más popular del juego es la construcción. Se pueden construir nuevos ítems a partir de otros, cada uno tiene ciertos requisitos
% para poder construirse:
% - Puede requerir una cierta cantidad de un ítem simple, que es aquel que el jugador tiene o puede recolectar. Por ejemplo,
% 8 unidades de piedra.
% - Puede requerir un ítem compuesto, que se debe construir a partir de otros (una única unidad).
% Con la siguiente información, se pide relacionar un jugador con un ítem que puede construir. puedeConstruir/2

item(horno, [ itemSimple(piedra, 8) ]).
item(placaDeMadera, [ itemSimple(madera, 1) ]).
item(palo, [ itemCompuesto(placaDeMadera) ]).
item(antorcha, [ itemCompuesto(palo), itemSimple(carbon, 1) ]).

% ?- puedeConstruir(stuart, horno).
% true.
% ?- puedeConstruir(steve, antorcha).
% true.

puedeConstruir(Jugador,Item):-
    jugador(Jugador,_,_),
    item(Item,ItemsRequeridos),
    forall(member(Miembro,ItemsRequeridos),tieneItemRequerido(Jugador,Miembro)).

tieneItemRequerido(Jugador,itemSimple(Item,CantidadRequerida)):-
    tieneItem(Jugador,Item),
    cantidadDeItem(Jugador,Item,Cantidad),
    Cantidad >= CantidadRequerida.

tieneItemRequerido(Jugador,itemCompuesto(Item)):-
    puedeConstruir(Jugador,Item).
    













    








