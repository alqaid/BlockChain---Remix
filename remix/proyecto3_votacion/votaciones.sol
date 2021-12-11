// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;
pragma experimental ABIEncoderV2;


// -----------------------------------
//  CANDIDATO   |   EDAD   |      DNI
// -----------------------------------
//  Toni        |    20    |    12345X
//  Alberto     |    23    |    54321T
//  Joan        |    21    |    98765P
//  Javier      |    19    |    56789W

//Toni,20,12345X
//Alberto,23,54321T
//Joan,21,98765P
//Javier,19,56789W

contract votacion{
    // Dirección del propietario
    address owner;

    constructor () {
        owner = msg.sender;
    }


// ============================ RELACCIONES ============================
    // Relacción entre el nombre y hash de datos personales
    mapping (string=>bytes32) mapping_Id_Candidato;

    // Relacción entre nombre candidato y número votos
    mapping (string=>uint) mapping_votos_Candidato;

// ============================ LISTAS ============================
    // Lista de candidatos
    string [] Lista_Candidatos;

    // Lista de votantes  sin IDENTIFICACIÓN Y  ÚNICA
    // Almacenamos el HASH de la Dirección, 
    //      1º por que ocupa menos espacio que la dirección de los votantes.

    bytes32 [] Lista_Votantes;

// ============================ FUNCIONES ============================

    // función Presentarse a Elecciones , PUBLICA PARA CUALQUIER CANDIDATO.
    function f_Representar(string memory _nombrePersona, uint _edadPersona, string memory _DNI) 
        public
        {
            // HASH de los datos personales  
            bytes32 hash_candidato= keccak256(abi.encodePacked(_nombrePersona,_edadPersona,_DNI));
            // guardamos el hash
            mapping_Id_Candidato[_nombrePersona] = hash_candidato;

            // Almacenmos nombre del candidato
            Lista_Candidatos.push(_nombrePersona);
        }

    // función Lista de Candidatos, y devuelve lista de Candidatos que se han apuntado
    // ponemos VIEW devuelve datos pero accede a un dato interno Candidatos
    //         PURE si no accediera a datos, solo devolviera
        function f_verCandidatos() 
        public view 
        returns (string[] memory)
        {
            return Lista_Candidatos;
        }

    // función votantes votan a un candidato , PUBLICA PARA CUALQUIER CANDIDATO. 
    // ¡¡¡¡  IMPORTANTE: SOLO 1 VEZ CADA VOTANTE  !!!!

    // modificador para chequear 1 solo voto por persona.
    modifier checkVotante(address _direccion) {
        bytes32 hash_votante = keccak256(abi.encodePacked(_direccion));
        for(uint i = 0; i < Lista_Votantes.length; i++) {
            require(Lista_Votantes[i] != hash_votante, "Ya has votado. No puedes volver a votar");
            _;
        }
        Lista_Votantes.push(hash_votante);
    }

    function f_Votar(string memory _candidato) 
        public
        checkVotante(msg.sender)
        {
           mapping_votos_Candidato[_candidato]++;
        }


    // función Presentarse a Elecciones , PUBLICA PARA CUALQUIER CANDIDATO.
    //function f_Representar(string memory _nombrePersona) 
   //     public
   //   {
   //   }
}

