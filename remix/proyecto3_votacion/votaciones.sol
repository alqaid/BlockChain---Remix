// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.4 <0.7.0;
pragma experimental ABIEncoderV2;


// IMPORTANTE LA VERSIÓN 0.4.4 A 0.7 sinó la función transformar uint to string no funciona

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

    constructor  () public {
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

// OPCIÓN 1 
 function f_Votar(string memory _candidato) 
        public
        {
            bytes32 hash_votante = keccak256(abi.encodePacked(msg.sender));
            for(uint i = 0; i < Lista_Votantes.length; i++) {
            require(Lista_Votantes[i] != hash_votante, "Ya has votado. No puedes volver a votar");
            }
            Lista_Votantes.push(hash_votante);
            mapping_votos_Candidato[_candidato]++;
        }

// OPCIÓN 2 CON MODIFICADOR
    // modificador para chequear 1 solo voto por persona.
    modifier checkVotante(address _direccion) {
        bytes32 hash_votante = keccak256(abi.encodePacked(_direccion));
        for(uint i = 0; i < Lista_Votantes.length; i++) {
            require(Lista_Votantes[i] != hash_votante, "Ya has votado. No puedes volver a votar");
            _;
        }        
    }

    function f_Votar2(string memory _candidato) 
        public
        checkVotante(msg.sender)
        {
            bytes32 hash_votante = keccak256(abi.encodePacked(msg.sender));
            Lista_Votantes.push(hash_votante);
            mapping_votos_Candidato[_candidato]++;
        }



// VER LOS VOTOS DE UN CANDIDATO pasado
    function F_VerVotos(string memory _nombreCandidato) 
        public view
        returns (uint)
        {
            return mapping_votos_Candidato[_nombreCandidato];
        }


 // VER LOS VOTOS DE CADA CANDIDATO 
    function F_VerResultados() 
        public view
        returns (string memory)
        {
            string memory devolver="";

            for(uint i = 0; i < Lista_Candidatos.length; i++) {
                // abi.encodePacked --> convertir a bytes
                // string(bytes32)  --> para convertir a string
                devolver = string(
                    abi.encodePacked(
                        devolver,
                        "(",
                        Lista_Candidatos[i],
                        ",",
                        uint2str(F_VerVotos(Lista_Candidatos[i])),
                        ") --- "
                    ));
            }

            return devolver;
        }



// NOMBRE DEL CANDIDATO CON MÁS VOTOS
    function F_Ganador() 
        public view
        returns (string memory)
        {
            string memory Ganador= Lista_Candidatos[0];
            bool flag;
            // int = 1 ya que el 0 ya lo hemos añadido
            for(uint i = 1; i < Lista_Candidatos.length; i++) {
                if(mapping_votos_Candidato[Ganador] < mapping_votos_Candidato[Lista_Candidatos[i]]){
                    // si es mayor estricto, NUEVO GANADOR
                    Ganador = Lista_Candidatos[i];
                    flag = false;
                }else{
                    // si ES MENOR NO HACEMOS NADA 
                    // si hay empate:
                    if(mapping_votos_Candidato[Ganador] == mapping_votos_Candidato[Lista_Candidatos[i]]){
                       flag = true;
                    }
                }                
            }

            Ganador =string(abi.encodePacked(" El Ganador es ", Ganador));
            if (flag==true) Ganador = "¡ HAY EMPATE !";
            return Ganador;

        }



// Funcion auxiliar que transforma un uint a un string
function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
        if (_i == 0) {
            return "0";
        }
        uint j = _i;
        uint len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint k = len - 1;
        while (_i != 0) {
            bstr[k--] = byte(uint8(48 + _i % 10));
            _i /= 10;
        }
        return string(bstr);
    }
}

