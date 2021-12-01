pragma solidity >=0.4.4 <0.9.0;

// ==============================
// Variables y tipos de acceso:
// ==============================
// public   -- Accesible desde dentro y fuera del Contrato
// private  -- Accesible desde dentro del Contrato ni siquiera en Contratos heredados.
// internal -- Accesible desde dentro del Contrato y Contratos que lo hereden.

// ===============
// Modificadores 
// ===============
// Memory  Guardado de forma temporal
// Storage Guardado permanentemente en la BlockChain

// ===============
// Payable 
// ===============
// Payable Permite enviar y recibir ether



contract modificadores{

// Variables públicas
    uint public mi_entero =45;
    string public mi_string ="Prueba de texto publica";
    address public owner;

    constructor() public{
        owner = msg.sender;
    }
// Variables  privadas
    uint private mi_entero_privada = 10;
    bool private flag = true;


// funciones  para operar con variables Privadas
    function test(uint _k) public{
        mi_entero_privada=_k;
    }

    function get_mi_entero_privada() public view returns (uint){
        return mi_entero_privada;
    }

// Variables Internas

    bytes32 internal hash = keccak256(abi.encodePacked("vvvvvv"));
    address internal direccion = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;



}