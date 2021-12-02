pragma solidity >=0.4.4 <0.9.0;


contract CausasBeneficas{

    struct Causa{
        uint Id;
        string nombre;
        uint precio_objetivo;
        uint cantidad_recaudada;
    }

    uint contador_causas = 0;

    mapping (string=> Causa) mappingCausas;


    function nuevaCausa(string memory _nombre, uint _precio_objetivo) public payable{
        // cualquiere puede lanzar el constructur

        contador_causas = contador_causas ++;


        // paso a paso NECESITAMOS memory PARA DESTRUIR EL OBJETO INTERMEDIO.
        //>  Causa memory causa = Causa(contador_causas,_nombre,_precio_objetivo,0);
        //>  mappingCausas[_nombre]=causa;
 

        // sin memory sería ASÍ mucho mejor
         mappingCausas[_nombre]=Causa(contador_causas,_nombre,_precio_objetivo,0);


    }

    function agregarDonacion(string memory _nombre, uint _donar) private view returns(bool){
        //devuelve true si se puede añadir la donacion
        bool flag = false;
        Causa memory causa = mappingCausas[_nombre];

        if (causa.precio_objetivo >= (causa.cantidad_recaudada + _donar)){
            flag = true;
        }
        return flag;
    }

    
    function donar(string memory _nombre, uint _cantidad)public returns(bool){
        // donar a una causa si false no se puede donar, el precio objetivo se ha alcanzado
        bool aceptar_donacion =true;
        if (agregarDonacion(_nombre,_cantidad)){
            mappingCausas[_nombre].cantidad_recaudada= mappingCausas[_nombre].cantidad_recaudada + _cantidad;
        }else{
            aceptar_donacion = false;
        }
        return aceptar_donacion;
    }


    function comprobar_causa(string memory _nombre) public view returns(bool,uint){
        // devuelve true si hemos llegado al precio objetivo.

         bool limite_alcanzado =false;

         Causa memory causa = mappingCausas[_nombre];
         if (causa.cantidad_recaudada>= causa.precio_objetivo){
             limite_alcanzado =true;
         }

        return(limite_alcanzado,causa.cantidad_recaudada);

    }
}