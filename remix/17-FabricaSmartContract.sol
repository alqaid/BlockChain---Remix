pragma solidity >=0.4.4 <0.9.0;

/* 
************** ************** ************** ************** **************
************** ***** FABRICA DE CONTRATOS INTELIGENTES ********* ************
************** ************** ************** ************** **************  
    
---Por ejemplo Lo usamos para que permitir que cada cliente pueda crearse sus propios contratos 

---Como probarlo:
    1. Desplegamos el proyecto.
    2. Con Factory Creamos un nuevo contrato, con mi dirección personal. mi dire:( oxAAA..)
    3. Para ver el nuevo contrato pegamos en FABRICA id ( 0 , 1, 2 ) segun contratos creados.
    4. Nos devuelve la dirección del nuevo contrato ( oxBBB..), QUE ESTA A NUESTRO NOMBRE
    Como entro al nuevo contrato
    5. seleccionamos SmartContract2 y en At Adress pegamos la dirección ( oxBBB..)  
    6. --- mas abajo --- se ha desplegado el nuevo contrato
    7. Clic en OWNER nos devuelve quien es su propietario: ( oxAAA..)

    8. Podemos seguir desplegando SmartContract2 por sus direcciones, todos su propietario es el que lo creo.



-- DECLARAR
contract SmartContract1{
    function Factory(){

        address direccion_nuevo_contrato = address (new SmartContract2(<parametros>));

    }
}

contract SmartContract2{
    constructor (<parametros>) public {...}
}



*/

contract SmartContract1{

    // Almacenamiento de la información
    struct fabrica{
        uint id;
        address contrato;

    }
    uint cont =0;
    fabrica[] public FABRICA;
     

    function Factory() public {

        address direccion_nuevo_contrato = address (new SmartContract2(msg.sender));
        cont ++;
        FABRICA.push(fabrica(cont,direccion_nuevo_contrato));

    }
}

contract SmartContract2{
    // QUIEN ES EL PROPIETARIO DE ESTE NUEVO CONTRATO. 
    // Osea quien es su padre.
    address public owner;

    constructor (address _direccion)  {
        owner = _direccion;
    }
}

