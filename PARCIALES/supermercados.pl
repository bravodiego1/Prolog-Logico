% Parcial: Supermercados

% BASE DE CONOCIMIENTO:

%primeraMarca(Marca) 
primeraMarca(laSerenisima). 
primeraMarca(gallo). 
primeraMarca(vienisima). 

%precioUnitario(Producto,Precio) 
%donde Producto puede ser arroz(Marca), lacteo(Marca,TipoDeLacteo), salchicas(Marca,Cantidad) 
precioUnitario(arroz(gallo),25.10). 
precioUnitario(lacteo(laSerenisima,leche), 6.00). 
precioUnitario(lacteo(laSerenisima,crema), 4.00). 
precioUnitario(lacteo(gandara,queso(gouda)), 13.00). 
precioUnitario(lacteo(vacalin,queso(mozzarella)), 12.50). 
precioUnitario(salchichas(vienisima,12), 9.80). 
precioUnitario(salchichas(vienisima, 6), 5.80). 
precioUnitario(salchichas(granjaDelSol, 8), 5.10). 

%descuento(Producto, Descuento) 
descuento(lacteo(laSerenisima,leche), 0.20). 
descuento(lacteo(laSerenisima,crema), 0.70). 
descuento(lacteo(gandara,queso(gouda)), 0.70). 
descuento(lacteo(vacalin,queso(mozzarella)), 0.05). 

descuento(salchichas(Marca,_),0.50):-
    Marca \= vienisima.

descuento(arroz(_),1.50).

descuento(lacteo(_,leche),2).

descuento(lacteo(Marca,queso),2):-
    primeraMarca(Marca).

descuento(Producto,0.05):-
    mayorPrecioUnitario(Producto).

%compro(Cliente,Producto,Cantidad) 
compro(juan,lacteo(laSerenisima,crema),2). 

% Resolver los siguientes requerimentos usando los conceptos del paradigma lógico de modo que sean 
% completamente inversibles. 
% Importante: no usar = en ningún lugar de la resolución ni is si no se está resolviendo una operación aritmética.

% PUNTO 1
/*
1)  Desarrollar la lógica para agregar los siguientes descuentos 
- El arroz tiene un descuento del  $1.50.  
- Las salchichas tienen $0,50 de descuento si no son vienisima. 
- Los lacteos tienen $2 de descuento si son leches o quesos de primera marca. (el primera marca sólo se refiere 
a los quesos). 
- El producto con el mayor precio unitario tiene 5% de descuento. 
*/

mayorPrecioUnitario(Producto):-
    precioUnitario(Producto,Precio),
    not((precioUnitario(_,OtroPrecio),OtroPrecio > Precio)). 

/*2) Saber si un cliente es comprador compulsivo, lo cual sucede si compró todos los productos de primera marca 
que tuvieran descuento. */

esCompradorCompulsivo(Cliente):-
    compro(Cliente,_,_),
    forall((compro(Cliente,Producto,_),tipoDeProducto(Producto,Marca)),primeraMarca(Marca)).
    
tipoDeProducto(salchichas(Marca,_),Marca).

tipoDeProducto(lacteo(Marca,_),Marca).
  
tipoDeProducto(arroz(Marca),Marca).

/* Punto 3
Definir el predicado totalAPagar/2 que relaciona a un cliente con el total de su compra teniendo en cuenta que 
para cada producto comprado se debe considerar el precio con los descuentos que tenga.*/

totalAPagar(Cliente,PrecioTotal):- 
    compro(Cliente,Producto,Cantidad),
    precioCompra(Producto,Cantidad,PrecioTotal).
    
precioCompra(Producto,Cantidad,Precio):-
    precioUnitario(Producto,PrecioOriginal),
    findall(Descuento,descuento(Producto,Descuento),ListaDeDescuentos),
    sum_list(ListaDeDescuentos,DescuentoTotal),
    Precio is (PrecioOriginal - DescuentoTotal) * Cantidad.
    
/*
PUNTO 4
4) Definir clienteFiel/2 sabiendo que un cliente es fiel a la marca X cuando no compra nada de otra marca si 
también lo vende X. 
*/

clienteFiel(Cliente,Marca):-
    compro(Cliente,Producto,_),
    tipoDeProducto(Producto,Marca),
    not((compro(Cliente,Producto,_),tipoDeProducto(Producto,OtraMarca),OtraMarca \= Marca)).
