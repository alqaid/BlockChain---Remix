// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.4 <0.9.0;

//Versión exacta:           pragma solidity ^0.4.0;
//Rango de versiones:       pragma solidity >=0.7.0 <0.9.0;

//Rango actual en el momento de la creación de este: 0.8.10
//También fijarse en el compilador de REMIX.

/* COMENTARIOS */
/// @title <Contrato Estandard>
/// @author <Angel Alcaide>
/// @notice <Contrato estandard de iniciación>



// PARA EL USO  DE KECCAK
pragma experimental ABIEncoderV2;


contract funciones_globales{
    
    address owner;
 

  /*  constructor() public{
        //El Constructor se despliega una sola vez

        //inicializar la dirección que despliega el contrato
        owner = msg.sender;
        token = new ERC20Basic(1000);
    }*/

    //Devuelve la dirección del remitente de la llamada actual
    function MsgSender() public view returns(address){
        return msg.sender;
    }

    //Devuelve timestamp en segundos del bloque actual
    function TimeStamp() public view returns(uint){
        return block.timestamp;
    }

    //Devuelve dirección del minero que procesa el bloque
    function BlockCoinbase() public view returns(address){
        return block.coinbase;
    }

    //Devuelve la dificultad del bloque actual
    function BlockDifficulty() public view returns(uint){
        return block.difficulty;
    }

    //Devuelve el número del bloque actual
    function BlockNumber() public view returns(uint){
        return block.number;
    }

    //Devuelve 4 primeros datos de los datos enviados
    function MsgSig() public view returns(bytes4){
        return msg.sig;
    }

    //Devuelve Precio del gas de la transacción
    function txGasPrice() public view returns(uint){
        return tx.gasprice;
    }


    // Calcular hash  con la función keccak256(bytes)
    /* Usamos esta función para pasar a bytes distintos valores:
      --  abi.encodePacked(valor1,valor2,valor3,....)
      */
    function cacularHash1(string memory _cadena) public pure returns(bytes32){
        return keccak256(abi.encodePacked(_cadena));
    }

    // Calcular hash de varios argumentos
    function cacularHash2(string memory _cadena, uint _numero, address _direccion) public pure returns(bytes32){
        return keccak256(abi.encodePacked(_cadena,_numero,_direccion));
    }

     // Calcular hash de varios argumentos y algun añadido
    function cacularHash3(string memory _cadena, uint _numero, address _direccion) public pure returns(bytes32){
        string memory _variable ="asdf";
        uint _valor = 33;
        return keccak256(abi.encodePacked(_cadena,_numero,_direccion,_variable,_valor));
    }

}