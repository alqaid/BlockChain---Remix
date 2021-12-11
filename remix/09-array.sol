// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.4 <0.9.0;
//pragma experimental ABIEncoderV2;

// ==============================
// ARRAY :
// Relacciona un tipo de dato HOMOGENEO
// ==============================
/* 
    N ELEMENTOS DE O A N-1

************** ************** ************** ************** **************
************** ARRAY DE LONGITUD FIJA **************
************** ************** ************** ************** **************  
    <tipo de dato> [<longitud>] public* <nombre array> ;

--------Inicializar no es habitual:
     <tipo de dato> [<longitud>] public* <nombre array> = [valores];

--------acceder a un array:
    <nombre array>[<posicion>];

--------fijar un valor de un array:
    <nombre array>[<posicion>] = valor;


************** ************** ************** ************** **************
************** ARRAY DE LONGITUD DINÁMICA **************
************** ************** ************** ************** *************
    <tipo de dato> [] public* <nombre array> ;
--------Inicializar no es habitual es igual al de longitud fija:
     <tipo de dato> [] public* <nombre array> = [valores];

------ Introducir valores SOLO array dinámco
    <nombre array>.push(valor);

------ Longitud del array  array dinámco o fija (aunque ya lo sabemos)
    <nombre array>.length;
 ************** ************** ************** ************** ************** 
*/ 


contract ContratoArrays{

// EJEMPLO 1 : Array enteros longitud fija

    string[12] public meses = ["Enero","Febrero","Marzo","Abril"];

// EJEMPLO 2 : Array DINÁMICA   

    uint[] array_entero;

// EJEMPLO 3 : Array Complejo   

    struct Persona{
        string nombre;
        uint edad;
    }

    Persona[] public personas;
 

// funciones

    function fnuevaPersona(string memory _nombre, uint _edad) public {
        //ejemplo 2
        array_entero.push(_edad);

        //ejemplo 3
        personas.push(Persona(_nombre,_edad));
    }

    function longitud() public view returns (uint){
        // OJO para acceder a la ultima posicion longitud -1
        return personas.length;
    }
   
    function fverEdades(uint _n) public view returns (uint){
        return array_entero[_n];
    }

// VISUALIZAR LOS ARRAYS
    function fverMeses() public view  returns(string[12] memory){
        return meses;
    }

    function fverEdades() public view  returns(uint[] memory){
        return array_entero;
    }
 
}