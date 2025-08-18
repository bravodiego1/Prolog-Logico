% Parcial: La Leyenda de Aang.

% BASE DE CONOCIMIENTO:

% esPersonaje/1 nos permite saber qué personajes tendrá el juego
esPersonaje(aang).
esPersonaje(katara).
esPersonaje(zoka).
esPersonaje(appa).
esPersonaje(momo).
esPersonaje(toph).
esPersonaje(tayLee).
esPersonaje(zuko).
esPersonaje(azula).
esPersonaje(iroh).
esPersonaje(bumi). % PUNTO 6
esPersonaje(suki). % PUNTO 6

% esElementoBasico/1 nos permite conocer los elementos básicos que pueden controlar algunos personajes
esElementoBasico(fuego).
esElementoBasico(agua).
esElementoBasico(tierra).
esElementoBasico(aire).

% elementoAvanzadoDe/2 relaciona un elemento básico con otro avanzado asociado
elementoAvanzadoDe(fuego, rayo).
elementoAvanzadoDe(agua, sangre).
elementoAvanzadoDe(tierra, metal).

% controla/2 relaciona un personaje con un elemento que controla
controla(zuko, rayo).
controla(toph, metal).
controla(katara, sangre).
controla(aang, aire).
controla(aang, agua).
controla(aang, tierra).
controla(aang, fuego).
controla(azula, rayo).
controla(iroh, rayo). % PUNTO 6
controla(bumi,tierra). % PUNTO 6

% visito/2 relaciona un personaje con un lugar que visitó. Los lugares son functores que tienen la siguiente forma:
% reinoTierra(nombreDelLugar, estructura)
% nacionDelFuego(nombreDelLugar, soldadosQueLoDefienden)
% tribuAgua(puntoCardinalDondeSeUbica)
% temploAire(puntoCardinalDondeSeUbica)

visito(aang, reinoTierra(baSingSe, [muro, zonaAgraria, sectorBajo, sectorMedio])).
visito(iroh, reinoTierra(baSingSe, [muro, zonaAgraria, sectorBajo, sectorMedio])).
visito(zuko, reinoTierra(baSingSe, [muro, zonaAgraria, sectorBajo, sectorMedio])).
visito(toph, reinoTierra(fortalezaDeGralFong, [cuartel, dormitorios, enfermeria, salaDeGuerra, templo, zonaDeRecreo])).
visito(aang, nacionDelFuego(palacioReal, 1000)).
visito(katara, tribuAgua(norte)).
visito(katara, tribuAgua(sur)).
visito(aang, temploAire(norte)).
visito(aang, temploAire(oeste)).
visito(aang, temploAire(este)).
visito(aang, temploAire(sur)).
visito(bumi,reinoTierra(baSingSe, [muro, zonaAgraria, sectorBajo, sectorMedio])). % PUNTO 6
visito(suki,nacionDelFuego(prisionDeMaximaSeguridad,200)). % PUNTO 6


% A partir de estos hechos, nos pidieron lo siguiente:

% 1) Saber qué personaje esElAvatar. El avatar es aquel personaje que controla todos los elementos básicos.

esElAvatar(Personaje):-
    esPersonaje(Personaje),
    forall(esElementoBasico(Elemento),controla(Personaje,Elemento)).

% 2) clasificar a los personajes en 3 grupos:
% un personaje noEsMaestro si no controla ningún elemento, ni básico ni avanzado;
% un personaje esMaestroPrincipiante si controla algún elemento básico pero ninguno avanzado;
% un personaje esMaestroAvanzado si controla algún elemento avanzado. Es importante destacar que el avatar también es un maestro avanzado.

tipoDePersonaje(Personaje,Tipo):-
    esPersonaje(Personaje),
    clasificacion(Personaje,Tipo).
    
clasificacion(Personaje,Tipo):-
    elementosControladosPor(Personaje,ElementosControlados),
    clasificacionSegunElementos(ElementosControlados,Tipo).

clasificacion(Personaje,esMaestroAvanzado):-
    esElAvatar(Personaje).

elementosControladosPor(Personaje,Elementos):-
    findall(Elemento,controla(Personaje,Elemento),Elementos).

controlaElementoAvanzado(Elementos):-
    member(ElementoAvanzado,Elementos),
    elementoAvanzadoDe(_,ElementoAvanzado).

clasificacionSegunElementos([],noEsMaestro).

clasificacionSegunElementos(ElementosControlados,esMaestroPrincipiante):-
    member(Elemento,ElementosControlados),
    esElementoBasico(Elemento),
    not(controlaElementoAvanzado(ElementosControlados)).

clasificacionSegunElementos(ElementosControlados,esMaestroAvanzado):-
    controlaElementoAvanzado(ElementosControlados).

% 3) Saber si un personaje sigueA otro. Diremos que esto sucede si el segundo visitó todos los lugares que visitó el primero.
% También sabemos que zuko sigue a aang.

sigueA(Personaje,Otro):-
    esPersonaje(Personaje),
    esPersonaje(Otro),
    Personaje \= Otro,
    forall(visito(Personaje,Lugar),visito(Otro,Lugar)).

sigueA(aang,zuko).

% 4) Conocer si un lugar esDignoDeConocer, para lo que sabemos que:
% Todos los templos aire son dignos de conocer;
% La tribu agua del norte es digna de conocer;
% Ningún lugar de la nación del fuego es digno de ser conocido;
% Un lugar del reino tierra es digno de conocer si no tiene muros en su estructura.

esDignoDeConocer(Lugar):-
    visito(_,Lugar),
    cumpleCondicionDeDignidad(Lugar).

cumpleCondicionDeDignidad(temploAire(_)).

cumpleCondicionDeDignidad(tribuAgua(norte)).

cumpleCondicionDeDignidad(reinoTierra(_,Estructura)):-
    not(member(muro,Estructura)).

% 5) Definir si un lugar esPopular, lo cual sucede cuando fue visitado por más de 4 personajes. 

esPopular(Lugar):-
    visito(_,Lugar),
    personajesQueVisitaronElLugar(Lugar,Total),
    Total > 4.

personajesQueVisitaronElLugar(Lugar,Total):-
    findall(Personaje,visito(Personaje,Lugar),PersonajesVisitantes),
    list_to_set(PersonajesVisitantes,SinRepetidos),
    length(SinRepetidos,Total).

% 6) Por último nos pidieron modelar la siguiente información en nuestra base de conocimientos sobre algunos personajes desbloqueables
% en el juego:
% bumi es un personaje que controla el elemento tierra y visitó Ba Sing Se en el reino Tierra;
% suki es un personaje que no controla ningún elemento y que visitó una prisión de máxima seguridad en la nación del fuego protegida 
% por 200 soldados. 

% esPersonaje(bumi).
% esPersonaje(suki).

% controla(bumi,tierra).

% visito(bumi,reinoTierra(baSingSe, [muro, zonaAgraria, sectorBajo, sectorMedio])).
% visito(suki,nacionDelFuego(prisionDeMaximaSeguridad,200)).

/* SOLUCION ALTERNATIVA PUNTO 2:

clasificacion(UnPersonaje, UnaClasificacion) :-
  personaje(UnPersonaje),
  clasificacionPersonaje(UnPersonaje, UnaClasificacion).

clasificacionPersonaje(UnPersonaje, noEsMaestro) :-
  not(controla(UnPersonaje, _)).

clasificacionPersonaje(UnPersonaje, esMaestroPrincipiante) :-
  controla(UnPersonaje, _),
  not(controlaElementoAvanzado(UnPersonaje)).

controlaElementoAvanzado(UnPersonaje) :-
  controla(UnPersonaje, UnElemento),
  elementoAvanzadoDe(_, UnElemento).

clasificacionPersonaje(UnPersonaje, esMaestroAvanzado) :-
  controlaElementoAvanzado(UnPersonaje).

clasificacionPersonaje(UnPersonaje, esMaestroAvanzado) :-
  esElAvatar(UnPersonaje). */





















