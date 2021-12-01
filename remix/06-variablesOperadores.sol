pragma solidity >=0.4.4 <0.9.0;

// ==============================
// Comparación enteros:
// ==============================
/* 
    
    igualdad entero:       ==   O  !=
    igualdad BOOLEANOS:    !    &&     ||    ==   =!

*/
// ==============================
// OPERADORES
// ==============================
/* 
    
    básicos :   +  -   *  / 
    módulo  :   %
    exponenciación:   **    a**b  (a elevado a b )

*/


contract comparar{
    // 
    // no existe los racionales en solidity
    //
    uint a = 9;
    uint b = 2;

    uint public division= a/b;   // devuelve 4 truncado, NO REDONDEA
    uint public modulo= a%b;    // devuelve 1
    uint public exponenciar=  a**b; // (BASE  **  EXPONENTE)(9 elevado a 2 = 81)

    bool public test = a>=b;  //Devuelve TRUE



// funciones  para comparar
    function fcomparar(string memory _j, string memory _i) public pure returns(bool){
        bytes32 hash_j = keccak256(abi.encodePacked(_j));
        bytes32 hash_i = keccak256(abi.encodePacked(_i));

        if (hash_i == hash_j){
            return true;
        }else{
            return false;
        }
    }

// funcion Divisibilidad entre 5
    function fDivisibilidad(uint _k) public view returns(bool){
            uint ultima_cifra = _k % 10;
        if ((ultima_cifra==0)||(ultima_cifra==5)){
                return true;
        }else{
                return false;
        }
    }
 
}