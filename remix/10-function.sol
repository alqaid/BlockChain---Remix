pragma solidity >=0.4.4 <0.9.0;
//pragma experimental ABIEncoderV2;

// ==============================
// FUNCIONES :
// Por defecto la funcion es public aunque se recomienda ponerlo
// Privadas solo dentro del propio contrato, NO se acceden en herencia
// ==============================
/* 
     
************** ************** ************** ************** **************
************** ********* DEVOLUCIÓN DE VALORES  ************* ************
************** ************** ************** ************** **************  
    UNA FUNCIÓN PUEDE DEVOLVER VARIOS VALORES

    -- Declaración
        F() public/private returns(v1,v2,v3){}

    -- Asignación múltiple
        (v1,v2,v3) =  F();


        // con memory al acabar la funcion se elimina de la memoria.
         function f_hash(string memory _datos) private{}     

************** ************** ************** ************** **************
************** *********   MODIFICADORES    ************* ************
************** ********* view pure payable  ************* ************
************** ************** ************** ************** **************  
    Solo podemos usar uno a cada funcion

    view: No modifica los datos privados de un contrato.
          es necesario para retornar datos.

    pure: Función que no accede a datos del contrato. NI LEE NI ESCRIBE
          los valores solo dependen de los parametros de la funcion.

    payable: Permite recibir ether
             En remix en value podemos cambiar el valor de 0 a una cantidad que se cobrara 
             cada vez que se ejecute la funcion



*/ 
contract FuncionesGenerales{

    struct Alumnos{
        string nombre;
        uint edad;
        address direccion;
        bytes32 pass;
    }

    Alumnos[] public ListaAlumnos;
    
    function f_hash(string memory _datos) private pure returns(bytes32){
        //pure: no modifico datos por tanto 
        return keccak256(abi.encodePacked(_datos));
    }

    function nuevoAlumno(string memory _name, uint _edad ) public {
        bytes32 pass = f_hash(_name);
        address direc = msg.sender;
        ListaAlumnos.push(Alumnos(_name,_edad,direc,pass));
         
    }

    function division(uint _dividendo, uint _divisor)private pure returns(uint, uint, bool){
    //pure: no modifico datos por tanto 
    //  Devuelve Cociente  Resto   y si es o no Multiplo
        uint cociente= _dividendo/_divisor;
        uint resto= _dividendo % _divisor;
        bool multiplo = false;

        if (resto == 0 ){
            multiplo = true;
        }
        return (cociente,resto,multiplo);
    }


    // ASIGNACIÓN MULTIPLE

    uint public resltDivi_cociente;
    uint public resltDivi_resto;
    bool public resltDivi_multiple;

    function usardivision(uint _dividendo, uint _divisor) public{
        (resltDivi_cociente,resltDivi_resto,resltDivi_multiple)=division(_dividendo,_divisor);
    }



    // Modificador view 
    function verAlumno(uint _posicion) public view returns(string memory){
        return ListaAlumnos[_posicion].nombre;
    }



// ---------------------- PAYABLE ---------------------------------
    mapping (address => cartera) DineroCartera;
    struct cartera{
        Alumnos persona;  //DECLARADA ARRIBA
        uint dinero;
    }

    function fPagar(string memory _nombre,uint _edad, uint _cantidad)public payable{

        // con memory al acabar la funcion se elimina de la memoria.
        cartera memory mi_cartera;

        // estructura compleja, arriba declarada.
        // msg sender es la dirección de la persona que ejecutra la funcion
        Alumnos memory UnaPersona = Alumnos(_nombre,_edad,msg.sender,f_hash(_nombre));


        // ya tenemos una cartera.
        mi_cartera = cartera(UnaPersona,_cantidad);
        DineroCartera[msg.sender] = mi_cartera;

    }


    function fVerSaldo()public view returns(cartera memory){
        return DineroCartera[msg.sender];
    }

}