% Parcial: Who you gonna call?

% Base de conocimiento:

herramientasRequeridas(ordenarCuarto, [aspiradora(100), trapeador, plumero]).
herramientasRequeridas(limpiarTecho, [escoba, pala]).
herramientasRequeridas(cortarPasto, [bordedadora]).
herramientasRequeridas(limpiarBanio, [sopapa, trapeador]).
herramientasRequeridas(encerarPisos, [lustradpesora, cera, aspiradora(300)]).

% 1) Agregar a la base de conocimientos la siguiente información:
% Egon tiene una aspiradora de 200 de potencia.
% Egon y Peter tienen un trapeador, Ray y Winston no.
% Sólo Winston tiene una varita de neutrones.
% Nadie tiene una bordeadora.

tieneHerramienta(egon,aspiradora(200)).
tieneHerramienta(egon,trapeador).
tieneHerramienta(peter,trapeador).
tieneHerramienta(winston,varitaDeNeutrones).

% 2) Definir un predicado que determine si un integrante satisface la necesidad de una herramienta requerida. 
% Esto será cierto si tiene dicha herramienta, teniendo en cuenta que si la herramienta requerida es una aspiradora, 
% el integrante debe tener una con potencia igual o superior a la requerida.
% Nota: No se pretende que sea inversible respecto a la herramienta requerida.

satisfaceNecesidad(Integrante,Herramienta):-
    tieneHerramienta(Integrante,Herramienta).

satisfaceNecesidad(Integrante,aspiradora(PotenciaRequerida)):-
    tieneHerramienta(Integrante,aspiradora(Potencia)),
    between(0,Potencia,PotenciaRequerida).

% 3) Queremos saber si una persona puede realizar una tarea, que dependerá de las herramientas que tenga. Sabemos que:
% - Quien tenga una varita de neutrones puede hacer cualquier tarea, independientemente de qué herramientas requiera dicha tarea.
% - Alternativamente alguien puede hacer una tarea si puede satisfacer la necesidad de todas las herramientas requeridas para dicha tarea.

puedeRealizar(Persona,Tarea):-
    herramientasRequeridas(Tarea,_),
    tieneHerramienta(Persona,varitaDeNeutrones).

puedeRealizar(Persona,Tarea):-
    herramientasRequeridas(Tarea,ListaDeHerramientas),
    tieneHerramienta(Persona,_),
    forall(member(Herramienta,ListaDeHerramientas),satisfaceNecesidad(Persona,Herramienta)).

% 4) Nos interesa saber de antemano cuanto se le debería cobrar a un cliente por un pedido (que son las tareas que pide). 
% Para ellos disponemos de la siguiente información en la base de conocimientos:
% - tareaPedida/3: relaciona al cliente, con la tarea pedida y la cantidad de metros cuadrados sobre los cuales hay que realizar esa tarea.
% - precio/2: relaciona una tarea con el precio por metro cuadrado que se cobraría al cliente.
% Entonces lo que se le cobraría al cliente sería la suma del valor a cobrar por cada tarea, multiplicando el precio por 
% los metros cuadrados de la tarea.

tareaPedida(juan,ordenarCuarto,30).
tareaPedida(juan,cortarPasto,90).
tareaPedida(jorge,limpiarTecho,60).
tareaPedida(raul,cortarPasto,120).
tareaPedida(nacho,limpiarBanio,40).
tareaPedida(pepe,encerarPisos,70).

cliente(juan).
cliente(jorge).
cliente(raul).
cliente(nacho).
cliente(pepe).

precio(ordenarCuarto,500).
precio(limpiarTecho,1000).
precio(cortarPasto,800).
precio(limpiarBanio,900).
precio(encerarPisos,600).

precioQueSeLeCobraA(Cliente,Precio):-
    cliente(Cliente),
    findall(PrecioPorTarea,(tareaPedida(Cliente,Tarea,Metros),precio(Tarea,Monto),PrecioPorTarea is Monto * Metros),ListaPrecios),
    sumlist(ListaPrecios,Precio).











    


    


