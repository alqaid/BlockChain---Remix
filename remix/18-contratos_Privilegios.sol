// SPDX-License-Identifier: MIT
pragma solidity >=0.4.4 <0.7.0;
pragma experimental ABIEncoderV2;

/* 
************** ************** ************** ************** **************
************** ***** FABRICA DE CONTRATOS INTELIGENTES ********* ************
************** ************** ************** ************** **************  

Los contratos smartcontract2 son generados desde SmartContract1 y controlado por el.



---Como probarlo:
    1. Desplegamos el proyecto. SMC1
    2. Con Factory Creamos  2 CONTRATOS (la dirección de la cuenta la tengo prefijada)
    3. En CONTRATOS 0 o 1 sacamos los address del contrato creado.
    4. con los adrress en mapVerificar sacamos la estructura del contrato:
        {
            "0": "uint256: id 2",
            "1": "address: contrato 0x194146544073844DFdA12790823243f954F1A2D2",
            "2": "address: account 0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db"
        }

    5. Nos unimos a uno de ellos por ejemplo: al id 0

    6. cambiamos a smartcontract2
    7. cambiamos la cuenta a 0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db
    8. nos unimos con At Adress: 0x194146544073844DFdA12790823243f954F1A2D2
        (no creando con deploy eso genera otro contrato)

    9. Ya podemos generar nuevas viviendas, SE COMPRUEBA AL GRABAR QUE 
        EL CONTRATOS 0X1941...D2 se vincula al Account: 0x4B209...db

        sino el require evita grabación de la vivienda. 



TODO: CREAR EL SMARTCONTRACT1.
      CREAR LOS SMARCONTRACT2 desde OTRAS CUENTAS Y FUNCION VINCULAR.

      EN SMARTCONTRACT1 Debe verificar quien envia la vinculación, pero eso no se puede. 
          Ya que recibo siempre el msg.sender = direccion del contrato, no lo puedo probar.

      ¿Si envío la dirección del account COMO PARAMETRO la puedo falsear?


*/

contract SmartContract1{

    // Almacenamiento de la información
    struct fabrica{
        uint id;
        address contrato;
        address account;
    }
    uint cont =0;
    address [] public CONTRATOS;
    mapping (address => fabrica) public mapVerificar;
    
    function Factory() public {
        address albacete = 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2;
        address direccion_nuevo_contrato = address (new SmartContract2(address(this)));
        cont ++;
        mapVerificar[direccion_nuevo_contrato] = fabrica(cont,direccion_nuevo_contrato,albacete);
        CONTRATOS.push(direccion_nuevo_contrato);

        address cuenca = 0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db;
        address direccion_nuevo_contrato2 = address (new SmartContract2(address(this)));
        CONTRATOS.push(direccion_nuevo_contrato2);
        cont ++;
        mapVerificar[direccion_nuevo_contrato2] = fabrica(cont,direccion_nuevo_contrato2,cuenca);


    }


// Almacenamiento de la información COMPARTIDA
    struct Vivienda{
        string provincia;        
        address quien;
    }

    mapping (string => Vivienda) public Viviendas;    
    string [] arrayViviendas;

    function nuevaVivienda(address _direccion,string memory _provincia) public {
        address acc=mapVerificar[msg.sender].account;
        require(_direccion == acc,"Eres un listo");
        Viviendas[_provincia]= Vivienda(_provincia,acc);
        arrayViviendas.push(_provincia);
    }


    function cuenta() public returns(address) {
        address acc=mapVerificar[msg.sender].account;
        return acc;
    }
    
    function verViviendas() public view returns (string [] memory){
        return arrayViviendas;
    }

}


/* 
================================================================================
================================================================================
================================================================================
 */


contract SmartContract2{
    //  
    // address de la cuenta
    address public owner;

    // DIRECCIÓN DEL CONTRATO PADRE el que lo generó
    address public smc1;


    constructor (address _smc1) public  {
        owner = msg.sender;
        smc1 = _smc1;
    }


    function nuevaVivienda(  string memory _provincia) public {
        SmartContract1 SM1 = SmartContract1(smc1);
        SM1.nuevaVivienda(msg.sender,_provincia);
    }


    function cuenta() public returns(address) {
        SmartContract1 SM1 = SmartContract1(smc1);
        return SM1.cuenta();
    }
}