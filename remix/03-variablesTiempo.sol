pragma solidity >=0.4.4 <0.9.0;


contract variables_tiempo{


//   ------------------------------------------------------------------
// unidades de Tiempo  BASE son los segundos.

    // la hora del DESPLEGADO DEL  bloque , una vez inicializado ¡¡¡¡ no varía !!!
    uint public timest = block.timestamp;

    // igual, pero now está DEPRECATED
   // uint public hoy = now; 




    uint public minuto = 1 minutes;  // devuelve los segundos de 1 minuto
    uint public hora = 1 hours;  // devuelve los segundos de 1 hora
    uint public dias50 = 50 days; // devuelve los segundos de 50 dias
    uint public una_semana = 7 days; 

    function fnow() public view returns (uint){
        uint tiempo_actual;
      //  tiempo_actual = now;
        return tiempo_actual;
    }

    function ahora() public view returns (uint){
       return timest;
    } 

    function MasSegundos() public view returns (uint){
        return dias50;
    }

    function enTresDias() public view returns (uint){
        return  3 days;
    }

    function enUnaHora() public view returns (uint){
        return  hoy + 1 hours;
    }
}