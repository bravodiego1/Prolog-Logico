% Parcial: 31 Minutos.

% BASE DE CONOCIMIENTO:

% Cancion, Compositores, Reproducciones
cancion(bailanSinCesar, [pablollabaca, rodrigoSalinas], 10600177).
cancion(yoOpino, [alvaroDiaz, carlosEspinoza, rodrigoSalinas], 5209110).
cancion(equilibrioEspiritual, [danielCastro, alvaroDiaz, pablollabaca, pedroPeirano, rodrigoSalinas], 12052254).
cancion(tangananicaTanganana, [danielCastro, pablollabaca, pedroPeirano], 5516191).
cancion(dienteBlanco, [danielCastro, pablollabaca, pedroPeirano], 5872927).
cancion(lala, [pablollabaca, pedroPeirano], 5100530).
cancion(meCortaronMalElPelo, [danielCastro, alvaroDiaz, pablollabaca, rodrigoSalinas], 3428854).

% Mes, Puesto, Cancion
rankingTop3(febrero, 1, lala).
rankingTop3(febrero, 2, tangananicaTanganana).
rankingTop3(febrero, 3, meCortaronMalElPelo).
rankingTop3(marzo, 1, meCortaronMalElPelo).
rankingTop3(marzo, 2, tangananicaTanganana).
rankingTop3(marzo, 3, lala).
rankingTop3(abril, 1, tangananicaTanganana).
rankingTop3(abril, 2, lala).
rankingTop3(abril, 3, equilibrioEspiritual).
rankingTop3(mayo, 1, meCortaronMalElPelo).
rankingTop3(mayo, 2, lala).
rankingTop3(mayo, 3, equilibrioEspiritual).
rankingTop3(junio, 1, dienteBlanco).
rankingTop3(junio, 2, tangananicaTanganana).
rankingTop3(junio, 3, lala).

% 1) Saber si una cancion es un hit, lo cual ocurre si aparece en el ranking top 3 de todos los meses.
% Ejemplo: No hay ningun hit actualmente. A Tangananica Tanganana le falta estar en mayo y a Lala le falta abril y mayo.

esUnHit(Cancion):-
    cancion(Cancion,_,_),
    forall(rankingTop3(Mes,_,_),rankingTop3(Mes,_,Cancion)).

% 2) Saber si una cancion no es reconocida por los criticos, lo cual ocurre si tiene muchas reproducciones y nunca estuvo en el ranking.
% Una cancion tiene muchas reproducciones si tiene mas de 7000000 reproducciones.

noEsReconocida(Cancion):-
    cancion(Cancion,_,Reproducciones),
    tieneMuchasReproducciones(Reproducciones),
    nuncaEstuvoEnRanking(Cancion).

tieneMuchasReproducciones(Reproducciones):-
    Reproducciones > 7000000.

nuncaEstuvoEnRanking(Cancion):-
    not(rankingTop3(_,_,Cancion)).

% 3) Saber si dos compositores son colaboradores, lo cual ocurre si compusieron alguna cancion juntos.

sonColaboradores(Compositor,OtroCompositor):-
    cancion(_,Compositores,_),
    member(Compositor,Compositores),
    member(OtroCompositor,Compositores),
    Compositor \= OtroCompositor.

% En el noticiero 31 Minutos cada trabajador puede tener múltiples trabajos. Algunos de los tipos de trabajos que existen son:
% Los conductores, de los cuales nos interesa sus años de experiencia.
% Los periodistas, de los cuales nos interesa sus años de experiencia y su título, el cual puede ser licenciatura o posgrado.
% Los reporteros, de los cuales nos interesa sus años de experiencia y la cantidad de notas que hicieron a lo largo de su carrera.

% 4. Modelar en la solución a los siguientes trabajadores:
% a. Tulio, conductor con 5 años de experiencia.
% b. Bodoque, periodista con 2 años de experiencia con un título de licenciatura, y también reportero con 5 años de experiencia y 300 notas realizadas.
% c. Mario Hugo, periodista con 10 años de experiencia con un posgrado.
% d. Juanin, que es un conductor que recién empieza así que no tiene años de experiencia.

trabajador(tulio,conductor(5)).
trabajador(bodoque,periodista(2,licenciatura)).
trabajador(bodoque,reportero(5,300)).
trabajador(marioHugo,periodista(10,posgrado)).
trabajador(juanin,conductor(0)).

% 5) Conocer el sueldo total de una persona, el cual está dado por la suma de los sueldos de cada uno de sus trabajos.
% El sueldo de cada trabajo se calcula de la siguiente forma:
% a. El sueldo de un conductor es de 10000 por cada año de experiencia
% b. El sueldo de un reportero también es 10000 por cada año de experiencia más 100 por cada nota que haya hecho en su carrera.
% c. Los periodistas, por cada año de experiencia reciben 5000, pero se les aplica un porcentaje de incremento del 20% cuando
% tienen una licenciatura o del 35% si tienen un posgrado.

sueldoDePersona(Persona,SueldoTotal):-
    trabajador(Persona,_),
    sumaDeSueldos(Persona,SueldoTotal).

sumaDeSueldos(Persona,Sueldo):-
    findall(SueldoPorTrabajo,(trabajador(Persona,Trabajo),sueldoPorTrabajo(Trabajo,SueldoPorTrabajo)),SueldosDePersona),
    sumlist(SueldosDePersona,Sueldo).

sueldoPorTrabajo(conductor(AniosDeExperiencia),Sueldo):-
    Sueldo is AniosDeExperiencia * 10000.

sueldoPorTrabajo(reportero(AniosDeExperiencia,NotasRealizadas),Sueldo):-
    Sueldo is AniosDeExperiencia * 10000 + NotasRealizadas * 100.

sueldoPorTrabajo(periodista(AniosDeExperiencia,Titulo),Sueldo):-
    multiplicadorTitulo(Titulo,Multiplicador),
    Sueldo is (AniosDeExperiencia * 5000) * Multiplicador.

multiplicadorTitulo(licenciatura,1.20).

multiplicadorTitulo(posgrado,1.35).



