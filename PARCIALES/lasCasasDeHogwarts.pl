% Parcial: Las casas de Hogwarts.

% BASE DE CONOCIMIENTO:

mago(harry, mestiza, [coraje, amistad, orgullo, inteligencia]).
mago(ron, pura, [amistad, diversion, coraje]).
mago(hermione, impura, [inteligencia, coraje, responsabilidad, amistad, orgullo]).
mago(hannahAbbott, mestiza, [amistad, diversion]).
mago(draco, pura, [inteligencia, orgullo]).
mago(lunaLovegood, mestiza, [inteligencia, responsabilidad, amistad, coraje]).

odia(harry,slytherin).
odia(draco,hufflepuff).

casa(gryffindor).
casa(hufflepuff).
casa(ravenclaw).
casa(slytherin).

caracteriza(gryffindor,amistad).
caracteriza(gryffindor,coraje).
caracteriza(slytherin,orgullo).
caracteriza(slytherin,inteligencia).
caracteriza(ravenclaw,inteligencia).
caracteriza(ravenclaw,responsabilidad).
caracteriza(hufflepuff,amistad).
caracteriza(hufflepuff,diversion).

% Definir los siguientes predicados de modo que sean totalmente inversibles:

% 1) permiteEntrar/2 que relaciona a una casa con un mago. Este predicado se cumple para cualquier mago y cualquier
% casa excepto en el caso de Slytherin, que no permite entrar a magos de sangre impura.
% ?- permiteEntrar(slytherin, hermione).
% No.

permiteEntrar(Casa,Mago):-
    casa(Casa),
    mago(Mago,TipoDeSangre,_),
    cumpleCondicionesDeEntrada(Casa,TipoDeSangre).

cumpleCondicionesDeEntrada(Casa,_):-
    Casa \= slytherin.

cumpleCondicionesDeEntrada(slytherin,TipoDeSangre):-
    TipoDeSangre \= impura.

% 2) tieneCaracter/2 que relaciona a un mago y una casa si su carácter (lista de características) incluye todo lo que caracteriza a esa casa.
% ?- tieneCaracter(harry, Casa).
% Casa = gryffindor;
% Casa = slytherin;
% No.

tieneCaracter(Mago,Casa):-
    mago(Mago,_,CaracteristicasDeMago),
    casa(Casa),
    tieneLoNecesario(CaracteristicasDeMago,Casa).

tieneLoNecesario(CaracteristicasDeMago,Casa):-
    findall(Caracteristica,caracteriza(Casa,Caracteristica),CaracteristicasDeCasa),
    forall(member(Elemento,CaracteristicasDeCasa),member(Elemento,CaracteristicasDeMago)).

% 3) casaPosible/2 que relaciona a un mago con una casa en la cual podría quedar seleccionado. Esto se cumple si el mago tiene 
% el carácter adecuado para la casa, la casa permite su entrada y además el mago no odia esa casa.
% ?- casaPosible(harry, Casa).
% Casa = gryffindor;
% No.
% ?- casaPosible(hermione, Casa).
% Casa = gryffindor;
% Casa = ravenclaw;
% No.

casaPosible(Mago,Casa):-
    tieneCaracter(Mago,Casa),
    permiteEntrar(Casa,Mago),
    not(odia(Mago,Casa)).

% MAS BASE DE CONOCIMIENTO:

lugarProhibido(bosque,50).
lugarProhibido(seccionRestringida,10).
lugarProhibido(tercerPiso,75).

alumnoFavorito(flitwick, hermione).
alumnoFavorito(snape, draco).
alumnoOdiado(snape, harry).

hizo(ron, buenaAccion(jugarAlAjedrez, 50)).
hizo(harry, fueraDeCama).
hizo(hermione, irA(tercerPiso)).
hizo(hermione, responder(dondeSeEncuentraUnBezoar, 15, snape)).
hizo(hermione, responder(wingardiumLeviosa, 25, flitwick)).
hizo(ron, irA(bosque)).
hizo(draco, irA(mazmorras)).

% También sabemos en qué casa quedó efectivamente cada alumno mediante el predicado esDe/2 que relaciona a la persona con su casa.
% Este predicado es totalmente inversible.
% ?- esDe(harry, Casa).
% Casa = gryffindor;

esDe(harry,gryffindor).
esDe(hermione,gryffindor).
esDe(ron,gryffindor).
esDe(draco,slytherin).
esDe(lunaLovegood,ravenclaw).
esDe(hannahAbbott,hufflepuff).

% 4) Se pide desarrollar los siguientes predicados de modo que sean totalmente inversibles:
% esBuenAlumno/1 que se verifica para un mago que hizo al menos una acción y ninguna de las cosas que hizo provocó un puntaje negativo.

esBuenAlumno(Mago):-
    hizo(Mago,_),
    not((hizo(Mago,Accion),restaPuntaje(Accion))).

restaPuntaje(irA(Lugar)):-
    lugarProhibido(Lugar,_).
restaPuntaje(fueraDeCama).

% 5) puntosDeCasa/2 que relaciona a una casa con el puntaje total que es la sumatoria de los puntos obtenidos por los alumnos de esa casa.

puntajePorAccion(buenaAccion(_,Puntaje),Puntaje).

puntajePorAccion(fueraDeCama,-50).

puntajePorAccion(irA(Lugar),-Puntaje):-
    lugarProhibido(Lugar,Puntaje).

puntajePorAccion(irA(Lugar),0):-
    not(lugarProhibido(Lugar,_)).

puntajePorAccion(responder(_,PuntosDeRespuesta,Profesor),Puntaje):-
    hizo(Alumno,responder(_,PuntosDeRespuesta,Profesor)),
    alumnoFavorito(Profesor,Alumno),
    Puntaje is PuntosDeRespuesta * 2.

puntajePorAccion(responder(_,_,Profesor),0):-
    hizo(Alumno,responder(_,_,Profesor)),
    alumnoOdiado(Profesor,Alumno).

puntajePorAccion(responder(_,PuntosDeRespuesta,Profesor),PuntosDeRespuesta):-
    hizo(Alumno,responder(_,PuntosDeRespuesta,Profesor)),
    not(alumnoFavorito(Profesor,Alumno)),
    not(alumnoOdiado(Profesor,Alumno)).

puntajePorAlumno(Alumno,Puntaje):-
    mago(Alumno,_,_),
    findall(PuntosPorAccion,(hizo(Alumno,Accion),puntajePorAccion(Accion,PuntosPorAccion)),ListaDePuntosPorAlumno),
    sumlist(ListaDePuntosPorAlumno,Puntaje).

totalObtenido(Casa,Total):-
    findall(PuntosPorAlumno,(esDe(Alumno,Casa),puntajePorAlumno(Alumno,PuntosPorAlumno)),PuntajesDeAlumnosDeLaCasa),
    sumlist(PuntajesDeAlumnosDeLaCasa,Total).

puntosDeCasa(Casa,Total):-
    casa(Casa),
    totalObtenido(Casa,Total).

% 6) casaGanadora/1 que se verifica para aquella casa que haya obtenido una cantidad mayor de puntos que todas las otras.
% Suponiendo que los puntajes totales al terminar el año son:
% Gryffindor: 482 puntos.
% Slytherin: 472 puntos.
% Ravenclaw: 426 puntos.
% Hufflepuff: 352 puntos.
% ?- casaGanadora(Casa).
% Casa = gryffindor;
% No.

puntosDeCasaFinales(gryffindor,482).

puntosDeCasaFinales(slytherin,472).

puntosDeCasaFinales(ravenclaw,426).

puntosDeCasaFinales(hufflepuff,352).

casaGanadora(Casa):-
    puntosDeCasaFinales(Casa,Total),
    not((puntosDeCasaFinales(OtraCasa,OtroTotal), OtraCasa \= Casa, OtroTotal > Total)).

















    



