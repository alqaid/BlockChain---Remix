// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;
pragma experimental ABIEncoderV2;
//import "./ERC20.sol";

contract OMS_Covid{

    address public OMS;

    constructor ()  {
        OMS = msg.sender;
    }

// ============================= mappings  =============================  
    // Publico para que se pueda consultar que centros médicos tienen acceso o no
    mapping (address => bool) public mapping_Validacion_CentrosSalud;

    // Ejmeplo 1: 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4 -> true = TIENE PERMISOS PARA CREAR SU SMART CONTRACT
    // Ejmeplo 2: 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2 -> false = NO TIENE PERMISOS PARA CREAR SU SMART CONTRACT

    // RElaccionar address de un Centro Salud con su contrato
    mapping (address => address) public mapping_CentroSalud_Contrato;

// ============================= arrays  ============================= 

    address [] array_direcciones_contratos_de_centros_salud;

    address [] array_Solicitudes;
// ============================= eventos  ============================= 
    
    // Nuevo centro validado.
    // Cuando la OMS valida un centro y le da permisos
    event event_NuevoCentroValidado (address);

    // Este se lanza cuando hay un nuevo centro de salud.
    // Dirección del NUEVO CONTRATO, DIRECCIÓN DEL DUEÑO DEL CONTRATO
    event event_NuevoContrato(address, address);

    // Solicitud Acceso
    event event_SolicitudAcceso(address);

// ============================= Modificadores  ============================= 
    // Restrinje quien puede crear centros Clase 151
    modifier UnicamenteOMS(address _direccion){
        require(_direccion == OMS,"No tienes permiso para realizar esta funcion" );
        _;
    }

// ============================= Funciones =============================

    // CREAR nuevos centros de salud  Clase 152

    function CentrosSalud(address _centrosalud) public UnicamenteOMS(msg.sender){
        // Asignamos el estado de validez
        mapping_Validacion_CentrosSalud[_centrosalud] = true;
        // Emitimos el evento
        emit event_NuevoCentroValidado(_centrosalud);
    }

    // Crear contrato inteligente por cada Centro de Salud
    // Lo hace cada CENTRO DE SALUD que tenga PERMISOS
    function FactoryCentroSalud()public  {
        // Solo los centros de salud de ALTA EN LA OMS la pueden usar
        require(mapping_Validacion_CentrosSalud[msg.sender] == true,"No tienes permiso para ejecutar la funcion");

        // Generamos el smart contract
        address contrato_CentroSalud = address ( new CentroSalud(msg.sender));

        // LLenamos el array de contratos de salud
        array_direcciones_contratos_de_centros_salud.push(contrato_CentroSalud);

        // Alamacenar la relacion entre el centro de salud y su contrato
        mapping_CentroSalud_Contrato[msg.sender]=contrato_CentroSalud;

        // Emitimos el contrato
        emit event_NuevoContrato(contrato_CentroSalud, msg.sender);
    }

    // Solicitar acceso al SISTEMA MÉDICO
    function SolicitarAcceso()  public {
        // Almacenar la solicitud
        array_Solicitudes.push(msg.sender);
        // emitimos evento
        emit event_SolicitudAcceso(msg.sender);
    }

    // Solo la OMS VISUALIZA LAS SOLICITUDES PENDIENTES.
    function VisualizarSolicitudes() public view UnicamenteOMS(msg.sender) returns (address [] memory ) {
        return array_Solicitudes;
    }

}

// =============================  ============================= =============================
// =============================  ============================= =============================
// =============================  ============================= =============================


// ============================= CONTRATOS CENTROS DE SALUD =============================

contract CentroSalud{
// ============================= NUEVO CONTRATO  ============================= 

    address public DireccionCentroSalud;
    address public DireccionContrato;

    constructor (address _direccion)  {
        DireccionCentroSalud = _direccion;
        DireccionContrato = address(this);
    }

// ============================= estructura  =============================  
    struct struct_Resultados{
        bool diagnostico;
        string CodigoIPFS;
    }


// ============================= mappings  =============================  
    
    // Mapping de los resultados  Relacción de una persona con pruebas de covid
    mapping (bytes32 => struct_Resultados) mapping_ResultadosCovid;
// ============================= EVENTOS  =============================  


    event event_NuevoResultado (bool,string);

// ============================= MODIFIERS  =============================  
    
    modifier UnicamenteCentroSalud(address _direccion){
        require(_direccion == DireccionCentroSalud,"No tienes permiso para realizar esta funcion" );
        _;
    }

// ============================= FUNCIONES  =============================  
  // clase 158
  // Emitir resultado prueba COVID ---  ID DE PERSONA --- RESULTADO ---- CÓDIGO IPFS
  // Ejemplo CID: QmaNxbQNrJdLzzd8CKRutBjMZ6GXRjvuPepLuNSsfdeJRJ
  // URL: https://ipfs.io/ipfs/QmaNxbQNrJdLzzd8CKRutBjMZ6GXRjvuPepLuNSsfdeJRJ?filename=sample.pdf
  function ResultadosPruebaCOVID
    (string memory _dni, bool _resultadoCovid, string memory _codigoIPFS)
    public 
    UnicamenteCentroSalud(msg.sender) {
      // HASH del DNI
      bytes32 hash_DNI = keccak256(abi.encodePacked(_dni));

      // Guardar resultado COVID
      mapping_ResultadosCovid[hash_DNI] = struct_Resultados(_resultadoCovid,_codigoIPFS);
 
      // Emitir el evento del diagnostico
      emit event_NuevoResultado(_resultadoCovid, _codigoIPFS);
  }

  // visualizar resultados CLASE 160
  function VisualizarResultados(string memory _dni) public view returns (string memory,string memory) {
      // HASH del cliente
    bytes32 hash_DNI = keccak256(abi.encodePacked(_dni));

      // retorno de un boolean
    string memory resultadoPrueba;
    if (mapping_ResultadosCovid[hash_DNI].diagnostico == true ){
        resultadoPrueba="Positivo";
    } else{
        resultadoPrueba="Negativo";
    }

    return(resultadoPrueba,mapping_ResultadosCovid[hash_DNI].CodigoIPFS);
  }


}


