% Parcial: Warrior Cats.

% BASE DE CONOCIMIENTO:

pertenece(estrellaDeFuego,clanDelTrueno).
pertenece(estrellaAzul,clanDelTrueno).
pertenece(tormentaDeArena,clanDelTrueno).

gato(estrellaDeFuego,6,[estrellaRota,patasNegras,corazonDeRoble]).

esDe(clanDelTrueno,granSicomoro).
esDe(clanDelTrueno,rocasDeLasSerpientes).
esDe(clanDelTrueno,hondonadaArenosa).
esDe(clanDelViento,cuatroArboles).
esDe(clanDelRio,rocasSoleadas).
esDe(clanDeLaSombra,vertedero).

patrulla(estrellaDeFuego,rocasSoleadas).
patrulla(tormentaDeArena,cuatroArboles).

seEncuentra(ave(paloma,5),cuatroArboles).
seEncuentra(ave(quetzal,15),rocasDeLasSerpientes).
seEncuentra(pez(atlantico),granSicomoro).
seEncuentra(rata(ratatouille,cocinero,15),cocinaParisina).
seEncuentra(rata(pinky,cientifico,22),laboratorio).

% 1)

esTraidor(Gato):-
    gato(Gato,_,Enemigos),
    pertenece(Gato,Clan),
    atacaGatoDeMismoClan(Enemigos,Clan).

atacaGatoDeMismoClan(Enemigos,Clan):-
    member(Enemigo,Enemigos),
    pertenece(Enemigo,Clan).

% 2)

sePuedenEnfrentar(Gato,OtroGato):-
    sonDeDistintosClanes(Gato,OtroGato),
    patrullanLaMismaZona(Gato,OtroGato).

sonDeDistintosClanes(Gato,OtroGato):-
    pertenece(Gato,Clan),
    pertenece(OtroGato,OtroClan),
    Clan \= OtroClan.

patrullanLaMismaZona(Gato,OtroGato):-
    patrulla(Gato,Zona),
    patrulla(OtroGato,Zona).

% 3)

esConcurrida(Zona):-
    esDe(_,Zona),
    condicionConcurrencia(Zona).

condicionConcurrencia(Zona):-
    findall(Gato,patrulla(Gato,Zona),GatosPatrulleros),
    length(GatosPatrulleros,Cantidad),
    Cantidad > 5.

condicionConcurrencia(cuatroArboles).

% 4)

esMiedoso(Gato):-
    pertenece(Gato,Clan),
    forall(patrulla(Gato,Zona),esDe(Clan,Zona)).

% 5)

esTravieso(Gato):-
    gato(Gato,EdadEnLunas,_),
    condicionTravieso(Gato,EdadEnLunas,_).

condicionTravieso(Gato,_):-
    forall(patrulla(Gato,Zona),esConcurrida(Zona)).

condicionTravieso(_,EdadEnLunas):-
    between(0,5,EdadEnLunas).

condicionTravieso(estrellaDeFuego,_).

% 6)

puedeAtrapar(Gato,Presa):-
    gato(Gato,_,_),
    noEsMiedoso(Gato),
    seEncuentra(Presa,_),
    condicionPresa(Presa).

noEsMiedoso(Gato):-
    not(esMiedoso(Gato)).

condicionPresa(ave(_,AltitudDeVuelo)):-
    between(0,9,AltitudDeVuelo).

condicionPresa(ave(paloma,_)).

condicionPresa(rata(ratatouille,cocinero,15)).

% 7)

experiencia(Gato,Experiencia):-
    gato(Gato,EdadEnLunas,EnemigosDerrotados),
    experienciaGatuna(EdadEnLunas,EnemigosDerrotados,Experiencia).

experienciaGatuna(EdadEnLunas,EnemigosDerrotados,Experiencia):-
    length(EnemigosDerrotados,Cantidad),
    Experiencia is Cantidad * EdadEnLunas.

% 8)

ganaUnEnfrentamiento(Gato,OtroGato):-
    gato(Gato,_,EnemigosVencidosGanador),
    gato(OtroGato,_,EnemigosVencidosPerdedor),
    EnemigosVencidosGanador > EnemigosVencidosPerdedor.