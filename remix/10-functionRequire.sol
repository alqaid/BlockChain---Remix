pragma solidity >=0.4.4 <0.9.0;

/* 
************** ************** ************** ************** **************
************** ***** FUNCIONES  REQUIRE ********* ************
************** ************** ************** ************** **************  
    
--- 
    function f () [] [] [] [] ([]) * {

        require (condicion, [mensaje condicion]);
    }
 

*/

contract FuncionesRequire{

//EJEMPLO 1: 
    //funcion requiere contraseña

    function password(string memory _pass) public pure returns (string memory){
        require(
                keccak256(abi.encodePacked("1234")) == keccak256(abi.encodePacked(_pass))
                ,"Contrasena Incorrecta"
                );
        return "Contrasena Correcta";
    }

//EJEMPLO 2:  
    //funcion que requiere un tiempo entre cada llamada a esta
     
    uint tiempo =0;
    uint public cartera=0;

    function pagar(uint _dinero) public returns(uint){
        require(block.timestamp > tiempo + 5 seconds,
            "Aun no puedes pagar"            
        );
        tiempo = block.timestamp;
        cartera = cartera + _dinero;
        return cartera;
    }

//EJEMPLO 3:  
//  
    string[] nombres;

    function nuevoNombre(string memory _nombre) public{
        for(uint i=0; i< nombres.length; i++){
            require(
                keccak256(abi.encodePacked(_nombre)) != keccak256(abi.encodePacked(nombres[i])),
                "ya esta en la lista"
                );            
        }     
        nombres.push(_nombre);   
    }

    function verNombre(uint _v) public view returns(string memory){
        return nombres[_v];
    }

 
}
 