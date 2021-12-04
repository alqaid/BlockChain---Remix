pragma solidity >=0.4.4 <0.9.0;

/* 
************** ************** ************** ************** **************
************** ***** LIBRERÍA SAFEMATH ********* ************
************** ************** ************** ************** **************  
    
--- Previene el overflow

    assert: 
            Previene errores que nunca deberían darse,
            salta error sino se cumple la condición.


    requiere: 
            Previene acciones que queremos evitar.
    
*/


import "./SafeMath.sol";


contract calculosSeguros{
        //declarar para que datos usamos librería
        using SafeMath for uint;


        // uso de las 3 funciones
        function suma(uint _a, uint _b) public pure returns(uint){
                return _a.add(_b);
        }

         function resta(uint _a, uint _b) public pure returns(uint){
                return _a.sub(_b);
        }

         function multiplicar(uint _a, uint _b) public pure returns(uint){
                return _a.mul(_b);
        }

}
