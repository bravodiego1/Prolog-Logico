% Parcial: Pokemon.

% BASE DE CONOCIMIENTO:

% pokemon(nombrePokemon,tipo).

pokemon(pikachu,electrico).
pokemon(charizard,fuego).
pokemon(venusaur,planta).
pokemon(blastoise,agua).
pokemon(totodile,agua).
pokemon(snorlax,normal).
pokemon(rayquaza,dragon).
pokemon(rayquaza,volador).

% entrenador(nombreEntrenador,pokemonDeEntrenador).

entrenador(ash,pikachu).
entrenador(ash,charizard).
entrenador(brock,snorlax).
entrenador(misty,blastoise).
entrenador(misty,venusaur).
entrenador(misty,arceus).

% 1)

esDeTipoMultiple(Pokemon):-
    pokemon(Pokemon,Tipo),
    pokemon(Pokemon,OtroTipo),
    Tipo \= OtroTipo.

% 2)

esLegendario(Pokemon):-
    esDeTipoMultiple(Pokemon),
    nadieLoTiene(Pokemon).

nadieLoTiene(Pokemon):-
    not(entrenador(_,Pokemon)).

% 3)

esMisterioso(Pokemon):-
    pokemon(Pokemon,Tipo),
    cumpleCondicionDeMisterio(Pokemon,Tipo).

cumpleCondicionDeMisterio(Pokemon,Tipo):-
    not((pokemon(OtroPokemon,Tipo), OtroPokemon \= Pokemon)).

cumpleCondicionDeMisterio(Pokemon,_):-
    nadieLoTiene(Pokemon).

% BASE DE CONOCIMIENTO:

movimiento(pikachu,fisico(mordedura,95)).
movimiento(pikachu,especial(impactrueno,40,electrico)).
movimiento(charizard,especial(garraDragon,100,dragon)).
movimiento(charizard,fisico(mordedura,95)).
movimiento(blastoise,defensivo(proteccion,10)).
movimiento(blastoise,fisico(placaje,50)).
movimiento(arceus,especial(impactrueno,40,electrico)).
movimiento(arceus,especial(garraDragon,100,dragon)).
movimiento(arceus,defensivo(proteccion,10)).
movimiento(arceus,fisico(placaje,50)).
movimiento(arceus,defensivo(alivio,100)).

% 4)

danioDeAtaque(fisico(_,Danio),Danio).

danioDeAtaque(defensivo(_,_),0).

danioDeAtaque(especial(_,Potencia,Tipo),Danio):-
    multiplicador(Tipo,Multiplicador),
    Danio is Potencia * Multiplicador.

multiplicador(Tipo,1.5):-
    esBasico(Tipo).

multiplicador(dragon,3).

multiplicador(Tipo,1):-
    not(esBasico(Tipo)),
    Tipo \= dragon.

esBasico(fuego).
esBasico(agua).
esBasico(planta).
esBasico(normal).

% 5)

capacidadOfensiva(Pokemon,Total):-
    movimiento(Pokemon,_),
    totalDeDanio(Pokemon,Total).

totalDeDanio(Pokemon,DanioTotal):-
    findall(Danio,(movimiento(Pokemon,Ataque),danioDeAtaque(Ataque,Danio)),ListaDeDanios),
    sumlist(ListaDeDanios,DanioTotal).

% 6)

esPicante(Entrenador):-
    entrenador(Entrenador,_),
    forall(entrenador(Entrenador,Pokemon),condicionPicante(Pokemon)).

condicionPicante(Pokemon):-
    capacidadOfensiva(Pokemon,Danio),
    Danio > 200.

condicionPicante(Pokemon):-
    esMisterioso(Pokemon).