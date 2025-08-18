% Parcial: Delivery de Comidas.

% BASE DE CONOCIMIENTO:

%composicion(plato, [ingrediente])%
composicion(platoPrincipal(milanesa),[ingrediente(pan,3),ingrediente(huevo,2),ingrediente(carne,2)]).
composicion(entrada(ensMixta),[ingrediente(tomate,2),ingrediente(cebolla,1),ingrediente(lechuga,2)]).
composicion(entrada(ensFresca),[ingrediente(huevo,1),ingrediente(remolacha,2),ingrediente(zanahoria,1),ingrediente(pan,6)]).
composicion(postre(budinDePan),[ingrediente(pan,2),ingrediente(caramelo,1)]).

%calorías(nombreIngrediente, cantidadCalorias)%
calorias(pan,30).
calorias(huevo,18).
calorias(carne,40).
calorias(caramelo,170).
calorias(tomate,4).

%proveedor(nombreProveedor, [nombreIngredientes])%
proveedor(disco, [pan, caramelo, carne, cebolla]).
proveedor(sanIgnacio, [zanahoria, lechuga, miel, huevo]).

/*Punto 1
1) caloriasTotal/2, que relaciona un plato con su cantidad total de calorías por porción.
Las calorías de un plato se calculan a partir de sus ingredientes.
P.ej. la milanesa tiene 206 calorías (30 * 3 + 18 * 2 + 40 * 2) por porción.
*/

caloriasTotal(Plato,CaloriasTotal):-
    composicion(Plato,ListaDeIngredientes),
    findall(CaloriasIngrediente,(member(ingrediente(Ingrediente,Cantidad),ListaDeIngredientes),calorias(Ingrediente,Calorias), 
            caloriasSegunCantidad(Cantidad,Calorias,CaloriasIngrediente)),ListaCaloriasTotalIngredientes),
    sumlist(ListaCaloriasTotalIngredientes,CaloriasTotal).

caloriasSegunCantidad(Cantidad,Calorias,CaloriasTotal):-
    CaloriasTotal is Cantidad * Calorias.

/* 3) platoSimpatico/1
Se dice que un plato es simpático si ocurre alguna de estas condiciones:
· incluye entre sus ingredientes al pan y al huevo.
· tiene menos de 200 calorías por porción.
En el ejemplo, la milanesa es simpática, mientras que el budín de pan no (tiene pan pero no
huevo, y tiene 230 calorías por porción).
Asegurar que el predicado sea inversible. */

platoSimpatico(Plato):-
    composicion(Plato,_),
    cumpleCondicionPlato(Plato).

cumpleCondicionPlato(Plato):-
    composicion(Plato,ListaDeIngredientes),
    member(ingrediente(pan,_),ListaDeIngredientes),
    member(ingrediente(huevo,_),ListaDeIngredientes).

cumpleCondicionPlato(Plato):-
    caloriasTotal(Plato,CaloriasTotal),
    between(0,200,CaloriasTotal).

/* 4) menuDiet/3
Tres platos forman un menú diet si: el primero es entrada, el segundo es plato principal, el
tercero es postre, y además la suma de las calorías por porción de los tres no supera 450. */

menuDiet(Plato1,Plato2,Plato3):-
    esEntrada(Plato1),
    esPlatoPrincipal(Plato2),
    esPostre(Plato3),
    caloriasDeTodoElMenu(Plato1,Plato2,Plato3,CaloriasDeTodoElMenu),
    between(0,450,CaloriasDeTodoElMenu).

caloriasDeTodoElMenu(Plato1,Plato2,Plato3,Total):-
    caloriasTotal(Plato1,Ct1),
    caloriasTotal(Plato2,Ct2),
    caloriasTotal(Plato3,Ct3),
    Total is (Ct1 + Ct2 + Ct3).

esEntrada(entrada(_)).

esPlatoPrincipal(platoPrincipal(_)).

esPostre(postre(_)).

/* 5) tieneTodo/2
Este predicado relaciona un proveedor con un plato, si el proveedor provee todos los
ingredientes del plato.
P.ej. Disco “tiene todo” para el budín de pan, pero no para la milanesa. */

tieneTodo(Proveedor,Plato):-
    proveedor(Proveedor,IngredientesDeProveedor),
    composicion(Plato,ListaDeIngredientes),
    forall(member(ingrediente(Ingrediente,_),ListaDeIngredientes),member(Ingrediente,IngredientesDeProveedor)).

% 6) ingredientePopular/1
% Decimos que un ingrediente es popular si hay más de 3 platos que lo incluyen.

ingredientePopular(Ingrediente):-
    composicion(_,ListaDeIngredientes),
    member(ingrediente(Ingrediente,_),ListaDeIngredientes),
    findall(Plato,(composicion(Plato,ListaOtrosIngredientes),member(ingrediente(Ingrediente,_),ListaOtrosIngredientes)),PlatosQueLoTienen),
    length(PlatosQueLoTienen,Cantidad),
    Cantidad >= 3.