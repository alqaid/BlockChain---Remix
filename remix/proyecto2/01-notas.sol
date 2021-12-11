// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;


// -----------------------------------
//  ALUMNO   |    ID    |      NOTA
// -----------------------------------
//  Marcos |    77755N    |      5
//  Joan   |    12345X    |      9
//  Maria  |    02468T    |      2
//  Marta  |    13579U    |      3
//  Alba   |    98765Z    |      5


/* 
************** ************** ************** ************** **************
******* *****            SISTEMA DE EVALUACIONES              ************
******* ***** APLICACIÓN DE NOTAS ENTRE ALUMNOS Y PROFESORES  ************
************** ************** ************** ************** **************  
    
---


*/

contract Contrato_Notas {
    //Dirección del profesor que es quien despliega el CONTRATO, desde su cuenta
    address public G_Profesor;

// ------ CONSTRUCTOR ------------------------------
    constructor () {
        G_Profesor = msg.sender;
    }

    // relacciono la identidad del alumno con su nota
    // LO TRATAMOS con el HASH no con el address
    mapping (bytes32 => uint) mapping_Notas;

    // Array de revisión del Examen
    string [] array_Revisiones;

// ------ EVENTOS ------------------------------
    // solo para ver en el log que todo está ok.
    
    event event_alumno_evaluado(bytes32,uint);
    event event_revision(string);


// ------ MODIFICADORES ------------------------------
   
    modifier modificador_UnicamenteProfesor(address _direccion){
        //Requiere que la dirección sea la del profesor
        // es el único que puede poner notas
        require(_direccion == G_Profesor,"No tienes permiso para crear notas.");
        _;
    }

// ------------------------- FUNCIONES ------------------------------


    function f_Evaluar(string memory _iDAlumno, uint _nota)
        public modificador_UnicamenteProfesor(msg.sender){
            //Función para evaluar a los alumnos
            // las nostas se relaccionan por un hash
            // Hash del Alumno
            bytes32 hash_idAlumno = keccak256(abi.encodePacked(_iDAlumno));

            //relacionamos hasy y nota
            mapping_Notas[hash_idAlumno]=_nota;

            //Emitir evento
            emit event_alumno_evaluado(hash_idAlumno, _nota);

    }

    // Función para ver las notas
    function f_VerNotas(string memory _iDAlumno)public view returns(uint){
         // Hash del Alumno
            bytes32 hash_idAlumno = keccak256(abi.encodePacked(_iDAlumno));
        // Nota del alumno por hash
        uint nota_alumno = mapping_Notas[hash_idAlumno];
        return nota_alumno;

    }

    //Pedir revisión del Examen
    function f_SolicitarRevision(string memory _iDAlumno) public {
        array_Revisiones.push(_iDAlumno);
        //Emiter evento
        emit event_revision(_iDAlumno);
    }

     //Ver revisiones del Examen PRIVADA DEL PROFESOR
    function f_VerRevision() public view 
        modificador_UnicamenteProfesor(msg.sender)
        returns(string[] memory){
        return array_Revisiones;
    }

}