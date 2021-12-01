pragma solidity >=0.4.4 <0.9.0;
//pragma experimental ABIEncoderV2;

// ==============================
// MAPPINGS:
// Relacciona un tipo de dato con otro
// ==============================
/* 
    
    mapping  ( tipo de dato => value) [public]* <nombre mapping>;

----- Guardar datos

    <nombre mapping> [_key] = _value;


----- Ver datos
    <nombre mapping> [_key] ;

*/ 


contract Mappings{

// EJEMPLO 1 : Relaccionar una dirección con un entero

    mapping ( address  => uint ) public Ejemplo1_mapping;

    function Ejemplo1_elegirNumero(uint _numero) public{
        Ejemplo1_mapping[msg.sender] = _numero;
    }

    function Ejemplo1_consultarNumero() public view returns(uint){
      return Ejemplo1_mapping[msg.sender];
    }


// EJEMPLO 2 : nombre de una persona con cantidad de dinero
    mapping ( string  => uint ) public Ejemplo2_dinero;

    function Ejemplo2_IngresarDinero(string memory _nombre, uint _cantidad) public {
      Ejemplo2_dinero[_nombre]= _cantidad;
    }

    function Ejemplo2_consultarDinero(string memory _nombre) public view returns(uint){
      return Ejemplo2_dinero[_nombre];
    }


// EJEMPLO 3 : tipo de dato Complejo
    struct Persona{
        string nombre;
        uint edad;
    }

    mapping ( uint  => Persona ) public personas;

    function fnuevaPersona(uint _numeroDNI, string memory _nombre, uint _edad) public {
        personas[_numeroDNI]= Persona(_nombre,_edad);
    }

  // declarar memory por devolver una estructura
    function fverPersona(uint dni) public view returns (Persona memory){
        return personas[dni];
    }

}