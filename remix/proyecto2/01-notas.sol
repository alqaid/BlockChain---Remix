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
    event event_revision(bytes32);


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

            // Hash del Alumno
            bytes32 hash_idAlumno = keccak256(abi.encodePacked(_iDAlumno));

            //relacionamos hasy y nota
            mapping_Notas[hash_idAlumno]=_nota;

            //Emitir evento
            emit event_alumno_evaluado(hash_idAlumno, _nota);

    }

}