% Parcial: Turf.

% Punto 1: Pasos al costado (2 puntos)
% Les jockeys son personas que montan el caballo en la carrera: tenemos a Valdivieso, que mide 155 cms y pesa 52 kilos, Leguisamo,
% que mide 161 cms y pesa 49 kilos, Lezcano, que mide 149 cms y pesa 50 kilos, Baratucci, que mide 153 cms y pesa 55 kilos,
% Falero, que mide 157 cms y pesa 52 kilos.

% También tenemos a los caballos: Botafogo, Old Man, Enérgica, Mat Boy y Yatasto, entre otros. Cada caballo tiene sus preferencias:
% a Botafogo le gusta que el jockey pese menos de 52 kilos o que sea Baratucci
% a Old Man le gusta que el jockey sea alguna persona de muchas letras (más de 7), existe el predicado atom_length/2
% a Enérgica le gustan todes les jockeys que no le gusten a Botafogo
% a Mat Boy le gusta les jockeys que midan mas de 170 cms
% a Yatasto no le gusta ningún jockey

% También sabemos el Stud o la caballeriza al que representa cada jockey
% Valdivieso y Falero son del stud El Tute
% Lezcano representa a Las Hormigas
% Y Baratucci y Leguisamo a El Charabón

% Por otra parte, sabemos que Botafogo ganó el Gran Premio Nacional y el Gran Premio República, Old Man ganó el Gran Premio República
% y el Campeonato Palermo de Oro y Enérgica y Yatasto no ganaron ningún campeonato. Mat Boy ganó el Gran Premio Criadores.

% Modelar estos hechos en la base de conocimientos e indicar en caso de ser necesario si algún concepto interviene a la hora de hacer
% dicho diseño justificando su decisión.

% jockey(Nombre,Altura,Peso).

jockey(valdivieso,155,52).
jockey(leguisamo,161,49).
jockey(lezcano,149,50).
jockey(baratucci,153,55).
jockey(falero,157,52).

caballo(botafogo).
caballo(oldMan).
caballo(energica).
caballo(matBoy).
caballo(yatasto).

preferencias(botafogo,Jockey):-
    jockey(Jockey,_,Peso),
    Peso < 52.

preferencias(botafogo,baratucci).

preferencias(oldMan,Jockey):-
    jockey(Jockey,_,_),
    atom_length(Jockey,Cantidad),
    Cantidad > 7.

preferencias(energica,Jockey):-
    jockey(Jockey,_,_),
    not(preferencias(botafogo,Jockey)).

preferencias(matBoy,Jockey):-
    jockey(Jockey,Altura,_),
    Altura > 170.

caballeriza(valdivieso,elTute).
caballeriza(falero,elTute).
caballeriza(lezcano,lasHormigas).
caballeriza(baratucci,elCharabon).
caballeriza(leguisamo,elCharabon).

gano(botafogo,granPremioNacional).
gano(botafogo,granPremioRepublica).
gano(oldMan,granPremioRepublica).
gano(oldMan,palermoDeOro).
gano(matBoy,granPremioCriadores).

% Punto 2: Para mí, para vos (2 puntos)
% Queremos saber quiénes son los caballos que prefieren a más de un jockey. Ej: Botafogo, Old Man y Enérgica son caballos
% que cumplen esta condición según la base de conocimiento planteada. El predicado debe ser inversible.

muchasPreferencias(Caballo):-
    caballo(Caballo),
    findall(Jockey,preferencias(Caballo,Jockey),ListaDeJockeys),
    length(ListaDeJockeys,JockeysTotales),
    JockeysTotales > 1.

% Punto 3: No se llama Amor (2 puntos)
% Queremos saber quiénes son los caballos que no prefieren a ningún jockey de una caballeriza. El predicado debe ser inversible.
% Ej: Botafogo aborrece a El Tute (porque no prefiere a Valdivieso ni a Falero), Old Man aborrece a Las Hormigas y Mat Boy aborrece
% a todos los studs, entre otros ejemplos.

aborreceA(Caballo,Caballeriza):-
    caballo(Caballo),
    caballeriza(_,Caballeriza),
    not((preferencias(Caballo,Jockey),caballeriza(Jockey,Caballeriza))).

% Punto 4: Piolines (2 puntos)
% Queremos saber quiénes son los jockeys "piolines", que son las personas preferidas por todos los caballos que ganaron un premio importante.
% El Gran Premio Nacional y el Gran Premio República son premios importantes.
% Por ejemplo, Leguisamo y Baratucci son piolines, no así Lezcano que es preferida por Botafogo pero no por Old Man.
% El predicado debe ser inversible.

esPremioImportante(granPremioNacional).

esPremioImportante(granPremioRepublica).

ganoPremioImportante(Caballo):-
    caballo(Caballo),
    gano(Caballo,Premio),
    esPremioImportante(Premio).

piolines(Jockey):-
    jockey(Jockey,_,_),
    forall(ganoPremioImportante(Caballo),preferencias(Caballo,Jockey)).

















