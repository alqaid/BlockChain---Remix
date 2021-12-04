pragma solidity >=0.4.4 <0.9.0;

/* 
************** ************** ************** ************** **************
************** ***** FUNCIONES  MODIFIER ********* ************
************** ************** ************** ************** **************  
    
--- Cambia el comportamiento de una funcion de manera ágil
--- Declaración:  Ojo requiere _; al final

    modifier <nombre modificador> (<parametros>){
        require(<condicion>);
        -;
    }


    function f () [] [] [] []  <nombre modificador>(<parametros>) returns ([])  {}

    
*/

contract Modificadores{

    //La dirección del propietario solo puede ejectuar una función
    // para probarlo desplegar con una cuenta y ejecutar con otra

    address public owner;

    constructor(){
        owner = msg.sender;
    }


// Ejemplo 1

    modifier soloPropietario(){
        require(
            msg.sender == owner,
            "No tienes permiso para ejecutar la funcion"
        );
        _;
    }

    function ejemplo1() public view soloPropietario() returns(string memory) {
        return "Ejecucion ok";
    }

// Ejemplo 2
// solo la ejecutan una serie de clientes.

    struct cliente {
        address direccion;
        string nombre;
    }

    mapping ( string => address) clientes;
 
    modifier soloClientes(string memory _nombre){
        require(clientes[_nombre] == msg.sender,"no es cliente");
        _;
    }

    function altaCliente(string memory _nombre) public {
        clientes[_nombre] = msg.sender;
    }

    function ejemplo2(string memory _nombre) public soloClientes(_nombre){
        // ---
    }


// Ejemplo 3
// edad de conducción, salta la excepción si => conducir(17)

    modifier MayorEdad(uint _edadMinima, uint _edadUsuario){
        require(_edadMinima <= _edadUsuario,"es menor de edad");
        _;
    }

    function conducir(uint _edad) public MayorEdad(18,_edad){
        // ---
    }

}