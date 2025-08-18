% Parcial: Pulp Fiction

% BASE DE CONOCIMIENTO:

personaje(pumkin,ladron([licorerias, estacionesDeServicio])).
personaje(honeyBunny,ladron([licorerias, estacionesDeServicio])).
personaje(vincent,mafioso(maton)).
personaje(jules,mafioso(maton)).
personaje(marsellus,mafioso(capo)).
personaje(winston,mafioso(resuelveProblemas)).
personaje(mia,actriz([foxForceFive])).
personaje(butch,boxeador).

pareja(marsellus, mia).
pareja(pumkin,honeyBunny).

%trabajaPara(Empleador, Empleado)
trabajaPara(marsellus, vincent).
trabajaPara(marsellus, jules).
trabajaPara(marsellus, winston).

% Sabiendo eso, resolver los siguientes predicados, los cuales deben ser completamente inversibles:
 
% 1. esPeligroso/1. Nos dice si un personaje es peligroso. Eso ocurre cuando:
% realiza alguna actividad peligrosa: ser matón, o robar licorerías. 
% tiene empleados peligrosos

esPeligroso(Personaje):-
    personaje(Personaje,Actividad),
    esPeligrosaActividad(Actividad).

esPeligroso(Personaje):-
    trabajaPara(Personaje,Empleado),
    esPeligroso(Empleado). 

esPeligrosaActividad(mafioso(maton)).

esPeligrosaActividad(ladron(ListaDeRobos)):-
    member(licorerias,ListaDeRobos).

/* 2. duoTemible/2 que relaciona dos personajes cuando son peligrosos y además son pareja o amigos. Considerar que Tarantino
también nos dió los siguientes hechos: */

amigo(vincent, jules).
amigo(jules, jimmie).
amigo(vincent, elVendedor).

sonPeligrosos(Personaje,OtroPersonaje):-
    esPeligroso(Personaje),
    esPeligroso(OtroPersonaje).

duoTemible(Personaje,OtroPersonaje):-
    sonPeligrosos(Personaje,OtroPersonaje),
    sonCercanos(Personaje,OtroPersonaje),
    Personaje \= OtroPersonaje.

sonCercanos(Personaje,OtroPersonaje):-
    amigo(Personaje,OtroPersonaje).

sonCercanos(Personaje,OtroPersonaje):-
    pareja(Personaje,OtroPersonaje).

/* Punto 3
estaEnProblemas/1: un personaje está en problemas cuando 
el jefe es peligroso y le encarga que cuide a su pareja
o bien, tiene que ir a buscar a un boxeador. 
Además butch siempre está en problemas. 
*/

%encargo(Solicitante, Encargado, Tarea). 
%las tareas pueden ser cuidar(Protegido), ayudar(Ayudado), buscar(Buscado, Lugar)
encargo(marsellus, vincent,   cuidar(mia)).
encargo(vincent,  elVendedor, cuidar(mia)).
encargo(marsellus, winston, ayudar(jules)).
encargo(marsellus, winston, ayudar(vincent)).
encargo(marsellus, vincent, buscar(butch, losAngeles)).

estaEnProblemas(butch).

estaEnProblemas(Personaje):-
    personaje(Personaje,_),
    tieneJefePeligroso(Personaje,Jefe),
    encargo(Jefe,Personaje,Actividad),
    cumpleEncargo(Jefe,Actividad).

tieneJefePeligroso(Personaje,Jefe):-
    trabajaPara(Jefe,Personaje),
    esPeligroso(Jefe).

cumpleEncargo(Jefe,cuidar(Persona)):-
    pareja(Jefe,Persona).

cumpleEncargo(_,buscar(Persona,_)):-
    personaje(Persona,boxeador).

/*Punto 4.  sanCayetano/1:  es quien a todos los que tiene cerca les da trabajo (algún encargo). 
Alguien tiene cerca a otro personaje si es su amigo o empleado. */

sanCayetano(Personaje):-
    personaje(Personaje,_),
    forall(personaQueTieneCerca(Personaje,Persona),leDaTrabajo(Personaje,Persona)).

leDaTrabajo(Personaje,Persona):-
    encargo(Personaje,Persona,_).

personaQueTieneCerca(Personaje,Persona):-
    amigo(Personaje,Persona).

personaQueTieneCerca(Personaje,Persona):-
    trabajaPara(Personaje,Persona).

%Punto 5. masAtareado/1. Es el más atareado aquel que tenga más encargos que cualquier otro personaje.

masAtareado(Personaje):-
    personaje(Personaje,_),
    cantidadDeEncargos(Personaje,Cantidad),
    not((personaje(OtroPersonaje,_), cantidadDeEncargos(OtroPersonaje,OtraCantidad), OtraCantidad > Cantidad)).

cantidadDeEncargos(Personaje,Cantidad):-
    findall(Encargo,encargo(_,Personaje,Encargo),ListaDeEncargos),
    length(ListaDeEncargos,Cantidad).

% 6. personajesRespetables/1: genera la lista de todos los personajes respetables. Es respetable cuando su actividad
% tiene un nivel de respeto mayor a 9. Se sabe que:
% Las actrices tienen un nivel de respeto de la décima parte de su cantidad de peliculas.
% Los mafiosos que resuelven problemas tienen un nivel de 10 de respeto, los matones 1 y los capos 20.
% Al resto no se les debe ningún nivel de respeto. 

personajesRespetables(ListaDePersonajes):-
    findall(Personaje,esRespetable(Personaje),ListaDePersonajes).

esRespetable(Personaje):-
    personaje(Personaje,Actividad),
    nivelDeRespeto(Actividad,Nivel),
    Nivel > 9.

nivelDeRespeto(mafioso(resuelveProblemas),10).

nivelDeRespeto(mafioso(maton),1).

nivelDeRespeto(mafioso(capo),20).

nivelDeRespeto(actriz(Peliculas),Nivel):-
    length(Peliculas,Cantidad),
    Nivel is Cantidad / 10.

% 7. hartoDe/2: un personaje está harto de otro, cuando todas las tareas asignadas al primero requieren interactuar con el
% segundo (cuidar, buscar o ayudar) o un amigo del segundo. Ejemplo:
% ? hartoDe(winston, vincent).
% true % winston tiene que ayudar a vincent, y a jules, que es amigo de vincent.

hartoDe(Personaje,OtroPersonaje):-
    personaje(Personaje,_),
    personaje(OtroPersonaje,_),
    forall(encargo(_,Personaje,Encargo),tieneRelacion(Encargo,OtroPersonaje)).

tieneRelacion(cuidar(OtroPersonaje),OtroPersonaje).

tieneRelacion(ayudar(OtroPersonaje),OtroPersonaje).

tieneRelacion(buscar(OtroPersonaje,_),OtroPersonaje).

tieneRelacion(Encargo,OtroPersonaje):-
    amigo(OtroPersonaje,Amigo),
    tieneRelacion(Encargo,Amigo).


/*Punto 8:

 Ah, algo más: nuestros personajes tienen características. Lo cual es bueno, porque nos ayuda a diferenciarlos cuando están
 de a dos. Por ejemplo: */

caracteristicas(vincent,  [negro, muchoPelo, tieneCabeza]).
caracteristicas(jules,    [tieneCabeza, muchoPelo]).
caracteristicas(marvin,   [negro]).

/*Desarrollar duoDiferenciable/2, que relaciona a un dúo (dos amigos o una pareja) en el que uno tiene al menos una característica
 que el otro no. */

duoDiferenciable(Personaje,OtroPersonaje):-
    personaje(Personaje,_),
    personaje(OtroPersonaje,_),
    tieneCaracteristicaQueElOtroNo(Personaje,OtroPersonaje).

tieneCaracteristicaQueElOtroNo(Personaje,OtroPersonaje):-
    caracteristicas(Personaje,ListaDeCaracteristicas1),
    caracteristicas(OtroPersonaje,ListaDeCaracteristicas2),
    member(Caracteristica,ListaDeCaracteristicas1),
    not(member(Caracteristica,ListaDeCaracteristicas2)).


    

 








    















