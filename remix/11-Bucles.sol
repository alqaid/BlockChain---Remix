pragma solidity >=0.4.4 <0.9.0;


/* 
     
************** ************** ************** ************** **************
************** ********* BUCLES Y CONDICIONES  ************* ************
************** ************** ************** ************** **************  
    for(<iniciador>;<comprobar>;<aumentar>){ }

    while(<condicion>){ ... <break;> ... }

*/
contract Eventos{

    address [] direcciones;

    constructor(){
         // solo desde la cuenta que se lanza se hace el constructor
         direcciones.push(msg.sender);
    }


// EJEMPLO for
//      guardamos el address del que ejecuta en el array direcciones
//      comprobamos si la dirección actual ya fue introducida

    function asociar() public {
        direcciones.push(msg.sender);
    }

    function comprobarDireccion() public view returns(bool, address){
        // para probar cambiar la dirección del deploy y asociar las direcciones

        //return false, 0x0000000 por defecto
        for(uint i=0; i<direcciones.length;i++){
            if (msg.sender == direcciones[i]){
                return (true,direcciones[i]);
            }
        }
    }

// EJEMPLO WHILE 
//      Fijamos tiempo
//      Al pulsar esperar, si aún no ha pasado el tiempo espera, false

    uint tiempo;

    function fijarTiempo() public{
        tiempo = block.timestamp;
    }

    function esperar()public view returns(bool){
        while(block.timestamp < (tiempo + 5 seconds)){
            return false;
        }
        return true;
    }



//  Ejemplo While numeros PRIMOS
//  Devolver el siguiente primo a uno dado

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