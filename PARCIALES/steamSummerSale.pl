/*La conocida plataforma de venta de juegos online creada por GabeN, Steam, 
está organizando una serie de ofertas de verano​, ​debe ser el verano más frío de la historia... 
ah, pará!, verano en el hemisferio norte. En fin, como buenos ayudantes con cuentas en Steam, 
veamos algunas cosas que hace la plataforma, que obviamente está programada en Prolog:
Los juegos se modelan con functores debido a que dependen de su género. Los mismos serán:
● accion(NombreDelJuego)
● mmorpg(NombreDelJuego, CantidadDeUsuarios)
● puzzle(NombreDelJuego, CantidadDeNiveles, Dificultad)
Se cuenta con el predicado juego/​2, que relaciona a un
juego con su precio.*/

%juego(accion(NombreDelJuego))
%juego(mmorpg(NombreDelJuego,CantidaDeUsuarios))
%juego(puzzle(NombreDelJuego,CantidadDeNiveles,Dificultad))

juego(accion(callOfDuty),5).
juego(accion(batmanAA),10).
juego(mmorpg(wow,5000000),30).  
juego(mmorpg(lineage2,6000000),15).    
juego(puzzle(plantsVsZombies,40,media),10).
juego(puzzle(tetris,10,facil),0).   

/*
También se cuenta con el predicado oferta​/2, que relaciona el nombre de un juego con el
porcentaje de descuento que este tiene
*/
oferta(callOfDuty,10).
oferta(plantsVsZombies,51).

/*A su vez, se tiene el predicado usuario​/3 que relaciona a un usuario con los nombres de los juegos
que ya posee y los distintos tipos de adquisiciones que planea realizar el mismo.
Las adquisiciones que puede realizar un usuario se encuentran modeladas con functores. Estas
pueden ser: una compra ​para sí mismo, donde se conoce el nombre del juego que se va a
comprar; o bien, un regalo​, donde se conoce el nombre del juego a regalar y además, el nombre
del usuario a quien se le hará dicho regalo.*/


/*
PUNTO 1
cuantoSale​/2: Relaciona un juego con su valor. Para los juegos con ofertas deberá considerarse
su precio con el descuento. Para los juegos que no tengan ofertas, debe considerarse su precio
original.
*/

nombreJuego(accion(Nombre),Nombre).
nombreJuego(mmorpg(Nombre,_),Nombre).
nombreJuego(puzzle(Nombre,_,_),Nombre).

cuantoSale(Juego,Precio):-
    precioJuego(Juego,Precio).

precioJuego(Juego,Precio):-
    juego(Juego,Precio),
    nombreJuego(Juego,Nombre),
    not(oferta(Nombre,_)).

precioJuego(Juego,Precio):- 
    juego(Juego,PrecioOriginal),
    nombreJuego(Juego,NombreDelJuego),
    oferta(NombreDelJuego,Descuento),
    Precio is (PrecioOriginal - (Descuento*PrecioOriginal)/100). 
    
    /*
PUNTO2
juegoPopular/​1: Depende del tipo de juego:
● los juegos de acción siempre son populares;
● los mmorpg cuando tienen más de un millón de usuarios;
● los juegos de puzzle cuando su dificultad es fácil o tienen
exactamente 25 niveles.*/


juegoPopular(Juego):-
    juego(Juego,_),
    esPopular(Juego).

esPopular(accion(_)).

esPopular(puzzle(_,25,_)).

esPopular(puzzle(_,_,facil)).

esPopular(mmorpg(_,CantidadDeUsuarios)):-
    CantidadDeUsuarios > 1000000.

/*
PUNTO3
tieneUnBuenDescuento/​1: Se considera que un juego tiene buen
descuento cuando el porcentaje del mismo es superior al 50%.*/

tieneBuenDescuento(Juego):-
    juego(Juego,_),
    nombreJuego(Juego,NombreDelJuego),
    oferta(NombreDelJuego,Descuento),
    Descuento > 50.
/*
adictoALosDescuentos​/1: Se considera adicto a un usuario cuando todos los 
juegos que va a adquirir tienen un descuento superior al 50%.
*/

usuario(nico,[batmanAA,plantsVsZombies,tetris],[compra(lineage2),regalo(batmanAA,fede)]).
usuario(fede,[],[regalo(callOfDuty,nico),regalo(wow,nico)]).
usuario(rasta,[lineage2],[regalo(plantsVsZombies,fede)]).
usuario(agus,[],[compra(fifa)]).
usuario(felipe,[plantsVsZombies],[compra(tetris)]).

adictoALosDescuentos(Usuario):-
    usuario(Usuario,_,TiposDeAdquisiciones),
    forall((member(Adquisicion,TiposDeAdquisiciones),cambiarNombreJuegoAJuegoCompleto(Adquisicion,Juego)),(tieneBuenDescuento(Juego))).

cambiarNombreJuegoAJuegoCompleto(compra(NombreJuego),JuegoCompleto):-
    juego(JuegoCompleto,_),
    nombreJuego(JuegoCompleto,NombreJuego).

cambiarNombreJuegoAJuegoCompleto(regalo(NombreJuego,_),JuegoCompleto):-
    juego(JuegoCompleto,_),
    nombreJuego(JuegoCompleto,NombreJuego).

juegoFuturo(Usuario,Juego):-
    usuario(Usuario,_,JuegosFuturos),
    member(Juego,JuegosFuturos).
    
% Solucion Alternativa
/* adictoALosDescuentos(Usuario):-
    usuario(Usuario,,),
    forall(juegoFuturo(Usuario,Juego),(cambiarNombreJuegoAJuegoCompleto(Juego,JuegoCompleto),tieneBuenDescuento(JuegoCompleto))).

cambiarNombreJuegoAJuegoCompleto(compra(NombreJuego),JuegoCompleto):-
    juego(JuegoCompleto,_),
    nombreJuego(JuegoCompleto,NombreJuego).
cambiarNombreJuegoAJuegoCompleto(regalo(NombreJuego,_),JuegoCompleto):-
    juego(JuegoCompleto,_),
    nombreJuego(JuegoCompleto,NombreJuego).

juegoFuturo(Usuario,Juego):-
    usuario(Usuario,_,JuegosFuturos),
    member(Juego,JuegosFuturos).
    
*/

/*PUNTO 4

fanaticoDe​/2: Un usuario es fanático de un género de juego si tiene al menos dos juegos de ese
género. Resolver sin utilizar findall/3. 

*/

fanaticoDe(Usuario,Genero):-
    usuario(Usuario,JuegosActuales,_),
    member(NombreDeJuego,JuegosActuales),
    member(OtroNombreDeJuego,JuegosActuales),
    NombreDeJuego \= OtroNombreDeJuego,
    sonDelMismoGenero(NombreDeJuego,OtroNombreDeJuego,Genero).

genero(NombreDeJuego,Genero):-
    tipo(NombreDeJuego,Genero).

sonDelMismoGenero(NombreDeJuego,OtroNombreDeJuego,Genero):-
    genero(NombreDeJuego,Genero),
    genero(OtroNombreDeJuego,Genero).

tipo(NombreDeJuego,accion):-
    juego(accion(NombreDeJuego),_).

tipo(NombreDeJuego,mmorpg):-
    juego(mmorpg(NombreDeJuego,_),_).

tipo(NombreDeJuego,puzzle):-
    juego(puzzle(NombreDeJuego,_,_),_).

/*
PUNTO 5
monotematico​/2: Un usuario es monotemático para un género si únicamente posee juegos de ese género.
*/

monotematico(Usuario,Genero):-
    usuario(Usuario,JuegosActuales,_),
    genero(_,Genero),
    forall(member(NombreDeJuego,JuegosActuales),genero(NombreDeJuego,Genero)).

/* PUNTO 6
buenosAmigos​/2: Dos usuarios son buenos
amigos si se van a regalar juegos populares
mútuamente.
*/

buenosAmigos(Usuario1,Usuario2):-
    vaARegalarJuegoPopular(Usuario1,Usuario2),
    vaARegalarJuegoPopular(Usuario2,Usuario1),
    Usuario1 \= Usuario2.

vaARegalarJuegoPopular(Usuario,OtroUsuario):-
    usuario(Usuario,_,JuegosFuturos),
    member(regalo(NombreJuego,OtroUsuario),JuegosFuturos),
    cambiarNombreJuegoAJuegoCompleto(regalo(NombreJuego,_),JuegoCompleto),
    juegoPopular(JuegoCompleto).  

/* PUNTO 7
cuantoGastará​/2: Relaciona un usuario con la cantidad de dinero que gastará en futuras compras y regalos.
*/

cuantoGastara(Usuario,Cantidad):-
    usuario(Usuario,_,ListaDeAdquisiciones),
    findall(Precio,precioPorJuego(ListaDeAdquisiciones,Precio),ListaDePrecios),
    sumlist(ListaDePrecios,Cantidad).

precioPorJuego(ListaDeAdquisiciones,Precio):-
    member(Adquisicion,ListaDeAdquisiciones),
    cambiarNombreJuegoAJuegoCompleto(Adquisicion,JuegoCompleto),
    juego(JuegoCompleto,Precio). 



    

    





    
