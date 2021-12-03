pragma solidity >=0.4.4 <0.9.0;

/* 
************** ************** ************** ************** **************
************** ***** MULTIPLES CONTRATOS - LIBRERIAS ********* ************
************** ************** ************** ************** **************  
    
---Declara    
    library <nombre 1>;

--- Importar Libreria 
    import <nombre libreria> from  "./archivo.sol";    


  --- Definir Libreria 
    using  <nombre libreria> for  <tipo dato>;  

    Atención:    * cualquier tipo de dato

*/

library funcionesGenerales{

    function siguientePrimo(uint _p) public pure returns(uint){
        uint contador = _p + 1;

        while (true){
            uint aux=2;
            bool primo = true;
            while(aux < contador){
                if ((contador % aux ) == 0){
                    primo = false;
                    break;
                }
                aux ++;
            }

            if (primo == true){
                break;
            }
            contador ++;
        
        }
        return contador;
    }

}


contract calculos{

    using funcionesGenerales for *;

    function CalPrimo(uint _v) public pure returns(uint){
        return _v.siguientePrimo();
    }

}