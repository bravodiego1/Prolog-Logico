% Parcial: Musica para todos.

% BASE DE CONOCIMIENTO:

% disco(artista, nombreDelDisco, cantidad, año).
disco(floydRosa, elLadoBrillanteDeLaLuna, 1000000, 1973).
disco(tablasDeCanada, autopistaTransargentina, 500, 2006).
disco(rodrigoMalo, elCaballo, 5000000, 1999).
disco(rodrigoMalo, loPeorDelAmor, 50000000, 1996).
disco(rodrigoMalo, loMejorDe, 50000000, 2018).
disco(losOportunistasDelConurbano, ginobili, 5, 2018).
disco(losOportunistasDelConurbano, messiMessiMessi, 5, 2018).
disco(losOportunistasDelConurbano, marthaArgerich, 15, 2019).

% De los artistas conocemos a su manager y sus característica:
% manager(artista, manager).
manager(floydRosa, habitual(15)).
manager(tablasDeCanada, internacional(cachito, canada)).
manager(rodrigoMalo, trucho(tito)).

% habitual(porcentajeComision)
% internacional(nombre, lugar)
% trucho(nombre) 

% 1. clasico. Permite deducir si un artista tiene un disco llamado loMejorDe o alguno con más de 100000 copias vendidas.

clasico(Artista):-
    disco(Artista,Disco,Copias,_),
    tieneDiscoClasico(Disco,Copias).

tieneDiscoClasico(loMejorDe,_).

tieneDiscoClasico(_,Copias):-
    Copias > 100000.

% 2. cantidadesVendidas Relaciona un artista con la cantidad total de unidades vendidas en la historia.

cantidadesVendidas(Artista,Total):-
    disco(Artista,_,_,_),
    discosVendidos(Artista,Total).

discosVendidos(Artista,Total):-
    findall(Unidades,disco(Artista,_,Unidades,_),UnidadesTotales),
    sumlist(UnidadesTotales,Total).

% 3. derechosDeAutor Relaciona a un artista con importe total en concepto de derechos de autor.
% Cada venta aporta 100 pesos al artista, descontando la parte que se cobra su manager, en caso de
% contar con uno (si no tiene manager, no se le descuenta nada)
% a. Un manager habitual se queda con un porcentaje de las ganancias de cada artista.
% b. Un manager internacional cobra un porcentaje de las ganancias que depende de su lugar
% de residencia. (Por ejemplo, para Canadá es un 5%, para México un 15%, etc)
% c. Un manager trucho se queda con todo.

derechosDeAutor(Artista,Total):-
    cantidadesVendidas(Artista,CopiasVendidas),
    totalSegunRepresentacion(Artista,CopiasVendidas,Total).

totalSegunRepresentacion(Artista,CopiasVendidas,Total):-
    manager(Artista,Manager),
    descuentoSegunManager(Manager,Descuento),
    Total is (CopiasVendidas * 100) * (1 - Descuento / 100).

totalSegunRepresentacion(Artista,CopiasVendidas,Total):-
    noTieneManager(Artista),
    Total is CopiasVendidas * 100.

descuentoSegunManager(habitual(Descuento),Descuento).

descuentoSegunManager(internacional(_,Lugar),Descuento):-
    porcentajeSegunLugar(Lugar,Descuento).

descuentoSegunManager(trucho(_),100).

porcentajeSegunLugar(canada,5).

porcentajeSegunLugar(mexico,15).

noTieneManager(Artista):-
    not(manager(Artista,_)).

% 4. namberuan Encontrar al artista autogestionado número 1 de un año, que es el artista sin manager
% con el disco que tuvo más unidades vendidas en dicho año. 

namberuan(Artista,Anio):-
    disco(Artista,_,Cantidad,Anio),
    noTieneManager(Artista),
    not((disco(OtroArtista,_,OtraCantidad,Anio), noTieneManager(OtroArtista), OtraCantidad > Cantidad)).












