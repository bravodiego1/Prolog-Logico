% Parcial: Rey Leon.

% BASE DE CONOCIMIENTO:

%comio(Personaje, Bicho)
comio(pumba, vaquitaSanAntonio(gervasia,3)).
comio(pumba, hormiga(federica)).
comio(pumba, hormiga(tuNoEresLaReina)).
comio(pumba, cucaracha(ginger,15,6)).
comio(pumba, cucaracha(erikElRojo,25,70)).
comio(timon, vaquitaSanAntonio(romualda,4)).
comio(timon, cucaracha(gimeno,12,8)).
comio(timon, cucaracha(cucurucha,12,5)).
comio(simba, vaquitaSanAntonio(remeditos,4)).
comio(simba, hormiga(schwartzenegger)).
comio(simba, hormiga(niato)).
comio(simba, hormiga(lula)).
comio(shenzi,hormiga(conCaraDeSimba)).

pesoHormiga(2).

%peso(Personaje, Peso)
peso(pumba, 100).
peso(timon, 50).
peso(simba, 200).
peso(scar, 300).
peso(shenzi, 400).
peso(banzai, 500).
peso(mufasa,600).

% 1) A falta de pochoclos... Definir los predicados que permitan saber:

% a) Qué cucaracha es jugosita: ó sea, hay otra con su mismo tamaño pero ella es más gordita.
% ?- jugosita(cucaracha(gimeno,12,8)).
% Yes

jugosita(cucaracha(Nombre,Tamanio,Peso)):-
    comio(_,cucaracha(OtroNombre,Tamanio,OtroPeso)),
    Nombre \= OtroNombre,
    Peso > OtroPeso.

% b) Si un personaje es hormigofílico... (Comió al menos dos hormigas).
% ?- hormigofilico(X).
% X = pumba;
% X = simba.

hormigofilico(Personaje):-
    comio(Personaje,hormiga(Nombre)),
    comio(Personaje,hormiga(OtroNombre)),
    Nombre \= OtroNombre.

% c) Si un personaje es cucarachofóbico (no comió cucarachas).
% ?- cucarachofobico(X).
% X = simba

cucarachofobico(Personaje):-
    comio(Personaje,_),
    not(comio(Personaje,cucaracha(_,_,_))).

% d) Conocer al conjunto de los picarones. Un personaje es picarón si comió una cucaracha jugosita ó si se
% come a Remeditos la vaquita. Además, pumba es picarón de por sí.
% ?- picarones(L).
% L = [pumba, timon, simba]

picarones(PersonajesPicarones):-
    findall(Personaje,esPicaron(Personaje),PersonajesPicarones).

esPicaron(pumba).
esPicaron(Personaje):-
    comio(Personaje,Cucaracha),
    jugosita(Cucaracha).
esPicaron(Personaje):-
    comio(Personaje,vaquitaSanAntonio(remeditos,_)).

/* 
2) Pero yo quiero carne...
Aparece en escena el malvado Scar, que persigue a algunos de nuestros amigos. Y a su vez, las hienas Shenzi
y Banzai también se divierten... */

persigue(scar, timon).
persigue(scar, pumba).
persigue(shenzi,pumba).
persigue(banzai,simba).
persigue(shenzi, simba).
persigue(shenzi, scar).
persigue(banzai, timon).
persigue(scar,mufasa).

/* a) Se quiere saber cuánto engorda un personaje (sabiendo que engorda una cantidad igual a la suma de
los pesos de todos los bichos en su menú). Los bichos no engordan.
?- cuantoEngorda(Personaje, Peso).
Personaje= pumba
Peso = 83;
Personaje= timon
Peso = 17; */

cuantoEngorda1(Personaje,Peso):-
    peso(Personaje,_),
    sumaTotalDeSuPeso(Personaje,Peso).

sumaTotalDeSuPeso(Personaje,Peso):-
    findall(PesoPorBicho,(comio(Personaje,Bicho),pesoPorBicho(Bicho,PesoPorBicho)),Pesos),
    sumlist(Pesos,Peso).

pesoPorBicho(vaquitaSanAntonio(_,Peso),Peso).

pesoPorBicho(cucaracha(_,_,Peso),Peso).

pesoPorBicho(hormiga(_),Peso):-
    pesoHormiga(Peso).

/* b) Pero como indica la ley de la selva, cuando un personaje persigue a otro, se lo termina comiendo, y por lo
tanto también engorda. Realizar una nueva version del predicado cuantoEngorda.
?- cuantoEngorda(scar,Peso).
Peso = 150
(es la suma de lo que pesan pumba y timon)
?- cuantoEngorda(shenzi,Peso).
Peso = 502
(es la suma del peso de scar y simba, mas 2 que pesa la hormiga) */

cuantoEngorda2(Personaje,Peso):-
    peso(Personaje,_),
    sumaTotalDeSuPeso2(Personaje,Peso).

sumaTotalDeSuPeso2(Personaje,Peso):-
    findall(PesoPorComida,(ingirioAlimento(Personaje,Comida),pesoPorComida(Comida,PesoPorComida)),Pesos),
    sumlist(Pesos,Peso).

ingirioAlimento(Personaje,Comida):-
    comio(Personaje,Comida).

ingirioAlimento(Personaje,Comida):-
    persigue(Personaje,Comida).

pesoPorComida(vaquitaSanAntonio(_,Peso),Peso).

pesoPorComida(cucaracha(_,_,Peso),Peso).

pesoPorComida(hormiga(_),Peso):-
    pesoHormiga(Peso).
    
pesoPorComida(Personaje,Peso):-
    peso(Personaje,Peso).

% 3) Buscando el rey...
% Sabiendo que todo animal adora a todo lo que no se lo come o no lo
% persigue, encontrar al rey. El rey es el animal a quien sólo hay un animal
% que lo persigue y todos adoran.
% Si se agrega el hecho:
% persigue(scar, mufasa).
% ?- rey(R).
% R = mufasa.
% (sólo lo persigue scar y todos los adoran)

rey(Personaje):-
    peso(Personaje,_),
    soloLoPersigueUno(Personaje),
    todosLoAdoran(Personaje).

soloLoPersigueUno(Personaje):-
    persigue(OtroPersonaje,Personaje),
    not((persigue(Otro,Personaje), OtroPersonaje \= Otro)).

todosLoAdoran(Personaje):-
    not(persigue(Personaje,_)).
    


