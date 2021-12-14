// SPDX-License-Identifier: MIT
pragma solidity >=0.4.4 <0.7.0;
pragma experimental ABIEncoderV2;
import "./ERC20.sol";

// SAFEMATH NO hace falta si no se usa aqui solo dentro de ERC20


contract Disney{

 // ============================= variables globales =============================    

    ERC20Basic private token;       // instancia a este contrato de los Tokens
    address payable  public owner;  // Dirección de DISNEY

    constructor () public {

        // instanciar el número de tokens 
        token = new ERC20Basic(1000);
        owner = msg.sender;

    }

 // ============================= STRUCTS =============================   

    struct cliente {
        uint token_comprados;
        string [] atracciones_disfrutadas;
    }

 // ============================= MAPPINGS =============================      

    mapping (address => cliente) public Clientes;

 // ============================= MODIFIERS =============================  

    modifier Unicamente(address _direccion){
        require(_direccion == owner, "No tienes permiso para ejecutar esta function");
        _;
    }
    
 // ============================= GESTION DE TOKENS =============================  

 // Función para establecer precio del Token. 
 // Conversión de token a eth.

    function PrecioToken(uint _numTokens) internal pure returns (uint){
        return _numTokens * (0.1 ether);
    }   

 // Función para comprar Tokens
 // usamos msgvalue para capturar los eth a comprar.

    function CompraTokens(uint _numTokens) public  payable{
        uint coste = PrecioToken(_numTokens);
        require (msg.value >= coste, "Compra menos Tokens o paga con mas ethers");

        // obtener la diferencia de lo que paga
        uint returnValue = msg.value - coste;

        // Disney retorna la cantidad de ethers al cliente
        msg.sender.transfer(returnValue);

        // Balance de tokens disponible
        uint Balance = f_balance();
        require(_numTokens <= Balance,"Compra un numero menor de Tokens");

        //cargar tokens a la cuenta del cliente
        token.transfer(msg.sender,_numTokens);

        // Almacenr en un registro.
        Clientes[msg.sender].token_comprados += _numTokens;
    }   

 // Función balance del contrato  DISNEY
  function f_balance() public view returns (uint){
    //Retornamos el número de tokens del contrato.
    //address(this) Es la dirección del contrato.
      return token.balanceOf(address(this));
   } 

 // número de tokens disponibles
    function MisTokens() public view returns (uint){
       return token.balanceOf(msg.sender);
    } 

 // Generar mas Tokens
    function GeneraTokens(uint _numTokens) public Unicamente(msg.sender){
        token.increaseTotalSuply(_numTokens);
    } 

 

}
