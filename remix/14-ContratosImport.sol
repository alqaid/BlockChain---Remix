pragma solidity >=0.4.4 <0.9.0;

import "./13_ContratosHerencia.sol";
/* 
     
************** ************** ************** ************** **************
************** ***** MULTIPLES CONTRATOS - IMPORT ********* ************
************** ************** ************** ************** **************  
    import "./<nombre 1>.sol";
     
    o subconjuntos
    import {<contratos>} from "./<nombre 1>.sol";

*/


contract OtroCliente is Banco{

    // alta Cliente
    function  AltaCliente(string memory _nombre) public {
        nuevoCliente(_nombre);
    }

}
