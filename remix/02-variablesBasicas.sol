// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.4 <0.9.0;


contract variables{ 

// EN SOLIDITY LOS NUMEROS RACIONALES NO ESTÁN IMPLEMENTADOS AÚN NO FUNCIONAN BIEN
// MULTIPLICAMOS *100 EN TODO CASO PARA TRABAJAR CON LA UNIDAD DEL EURO.
// Variables sin signo
    uint varUint = 5;

// Variables con signo

    int varInt1 = -5;

    int8 varInt8 = 127;  // rango -128 a 127
    int16 varInt9 = 18000;   // 
    int256 varInt256 = 30000;
 
// Variables bytes
    string vstring1;
    string cadena = "Hola mundo";

// Variables booleano
    bool vbool;
    bool vtrue = true;
    bool vfalse = false;

// Variables bytes
    bytes vunbyte;
    bytes4 vbyte4;
    bytes32 vbytes32;
    bytes32 hash = keccak256(abi.encodePacked("mi nombre"));
    //bytes256 vbytes256;
    function ejemploHash() public view returns(bytes32){
        return hash;
    }


// Variables adress Tipo de dato para las direcciónes de Ethereum 
// Dirección de 20 bytes
    address vaddress;
    address direccionLocal = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;

// variables PÚBLICAS PARA CONSULTAR

    bool public valorBooleano = false;
    string public hola = "Hola mundo";
    string public vacio;
    address public direccionL = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;



//   ------------------------------------------------------------------

// Enums -- Tipos de Datos Enumerables (SOLO SE MANEAJO ÍNDICES: 0 1 2 ....)
// --------------- Ejemplo   sOLO DEVUELVE 0 o 1
    enum estado{OFF, ON}

    estado interruptor;

    function encender() public{
        interruptor = estado.ON;
    }

    function apagar() public{
        interruptor = estado.OFF;
    }

    function fijarEstado(uint _v) public{
        interruptor = estado(_v);
    }

    function consultarEstado() public view returns(estado){
        // si OFF posición 0 ---devuelve 0
        // si ON  posición 1 ---devuelve 1
        return interruptor;
    }

// --------------- Ejemplo 2   sOLO DEVUELVE 0 , 1 , 2 , 3
    enum direcciones{ARRIBA, ABAJO , DERECHA , IZQUIERDA}
    direcciones direccion = direcciones.ARRIBA;

    function arriba() public{
        direccion = direcciones.ARRIBA;
    }
    function abajo() public{
        direccion = direcciones.ABAJO;
    }
    function derecha() public{
        direccion = direcciones.DERECHA;
    }
    function izquierda() public{
        direccion = direcciones.IZQUIERDA;
    }

    function fijarDireccion(uint _v) public{
        direccion = direcciones(_v);
    }

    function consultarDireccion() public view returns(direcciones){
        return direccion;
    }



}
