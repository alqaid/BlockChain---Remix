// SPDX-License-Identifier: MIT
pragma solidity >=0.4.4 <0.7.0;
pragma experimental ABIEncoderV2;
import "./OperacionesBasicas.sol";
import "./ERC20.sol";

// FActoria de Seguros

contract InsuranceFactory is OperacionesBasicas{

    constructor () public {
        token = new ERC20Basic(100);
        Insurance = address(this);
        Aseguradora = msg.sender;
    }

    ERC20basic private token;
    address Insurance;   //dirección del contrato General INSURANCE
    address payable public Aseguradora;  // dirección de la aseguradora
    


// ============================= estructuras  ============================= 
    struct cliente {
        address DireccionCliente;
        bool AutorizacionCliente;
        address DireccionContrato;
    }

    struct servicio {
        string NombreServicio;
        uint PrecioTokensServicio;
        bool EstadoServicio;
    }

    struct lab {
        address DireccionContratoLab;
        bool ValidacionLab;
    }
// ============================= mapping array  ============================= 
    mapping (address => cliente) public MappingAsegurados;
    mapping (string => servicio) public MappingServicios;   
    mapping (address => lab) public MappingLab;   

    string [] private nombreServicios; 
    address [] DireccionesLaboratorios;
    address [] DireccionesAsegurados;

// =============================MODIFICADORES RESTRICCIONES ============================= 

    function FuncionUnicamenteAsegurados(address _direccionAsegurado) public view{
        require(MappingAsegurados[_direccionAsegurado].AutorizacionCliente == true, "Direccion del Asegurado no Autorizada");

    }

    modifier UnicamenteAsegurados(address _direccionAsegurado){
        FuncionUnicamenteAsegurados(_direccionAsegurado);
        _;
    }

    modifier UnicamenteAseguradora(address _direccionAseguradora){
        require(Aseguradora == _direccionAseguradora,"Direccion de Aseguradora no Autorizada");
        _;
    }

    modifier Asegurado_o_Aseguradora(address _direccionAsegurado, address _direccionEntrante){
        require(
            (MappingAsegurados[_direccionEntrante].AutorizacionCliente == true
            && _direccionAsegurado == _direccionEntrante)
            || Aseguradora == _direccionEntrante
            ,"Solamente compania de seguros o asegurados"
        );
        _;
    }

  
// ============================= EVENTOS ============================= 

    event EventoComprado(uint256);
    event EventoServicioProporcionado(address,string, uint256);
    event EventoLaboratorioCreado(address,address);
    event EventoAseguradoCreado(address,address);
    event EventoBajaAsegurado(address);
    event EventoServicioCreado(string, uint256);
    event EventoBajaServicio(string);

// ============================= FUNCIONES Creación de SMART CONTRACT ============================= 

// Crear un laboratorio --> cualquiera lo puede dar de alta
    function creacionLab() public {
        DireccionesLaboratorios.push(msg.sender);
        // Creamos un laboratirio del Smart Contract LABORATORIO
        address direccionLab = address(new Laboratorio(msg.sender,Insurance));
        MappingLab[msg.sender] = lab(direccionLab, true);
        emit EventoLaboratorioCreado(msg.sender, direccionLab);
    }

    // Dar de alta un asegurado -> cualquiera lo puede dar de alta
    function creacionContratoAsegurado() public {
        DireccionesAsegurados.push(msg.sender);
        // Crear smartcontract de asegurado
        address direccionAsegurado = address(new InsuranceHealthRecord(msg.sender,token,Insurance,Aseguradora));
        MappingAsegurados[msg.sender] = cliente(msg.sender,true,direccionAsegurado);
        emit EventoAseguradoCreado(msg.sender, direccionAsegurado);
    }

// ============================= funciones ============================= 

    function Laboratorios() public view UnicamenteAseguradora(msg.sender) returns (address [] memory) {
        return DireccionesLaboratorios;
    }

    function Asegurados() public view UnicamenteAseguradora(msg.sender) returns (address [] memory) {
        return DireccionesAsegurados;
    }

    function consultarHistorialAsegurados(address _direccionAsegurado, address _direccionConsultor)
        public view Asegurado_o_aseguradora(_direccionAsegurado,_direccionConsultor)
        returns (string memory){
            string memory historial = "";
            address direccionContratoAsegurado = MappingAsegurados[_direccionAsegurado].DireccionContrato;
            for (uint i = 0; i < nombreServivios.length; i++){
                if (MappingServicios[nombreServicios[i]].estadoServicio 
                    && InsurenceHealthRecord(direccionContratoAsegurado).ServicioEstadoAsegurado(nombreServicio[i]) == true
                    ){
                        (string memory nombreServicio, uint precioServicio)= InsurenceHealthRecord(direccionContratoAsegurado).HistorialAsegurado(nombreServicio[i]);
                        historial = string(abi.encodePacked(historial, "(" , nombreservicio, ", " , uint2str(precioServicio), ") ----- "));
                    }
            }
            return historial;
    }

    function darBajaCliente(address _direccionAsegurado) 
        public UnicamenteAseguradora(msg.sender)
    {
        MappingAsegurados[_direccionAsegurado].AutorizacionCliente = false;
        // LLmar a la baja del Smart Contract
        InsuranceHealthRecord(MappingAsegurados[_direccionAsegurado].DireccionContrato).darBaja;
        emit EventoBajaAsegurado(_direccionAsegurado);
    }

}

// ============================= funciones de SERVICIOS============================= 
    function nuevoServicio(string memory _nombreServicio, uint256 _precioServicios) 
        public UnicamenteAseguradora(msg.sender)
        {
            MappingServicios[_nombreServicio]= servicio(_nombreServicio, _precioServicio, true);
            nombreServicios.push(_nombreServicio);
            emit EventoServicioCreado(_nombreServicio,_precioServicio);
        }

    function ServicioEstado(string memory _nombreServicio) 
        public returns (bool)
        {
            return MappingServicios[_nombreServicio].EstadoServicio;
        }

    function getPrecioServicio(string memory _nombreServicio) 
        public view returns (uint256 tokens)
        {
            require(ServicioEstado(_nombreServicio) == true, "El servicio no está disponible");
            return MappingServicios[_nombreServicio].PrecioTokensServicio;
        }

    function consultarServiciosActivos() public view returns (string [] memory)
    {
        string [] memory ServiciosActivos = new string[](nombreServicios.length);
        uint contador = 0;
        for (uint i=0 ; i< nombreServicios.length ; i++){
            if (ServicioEstado(nombreServicios[i])== true){
                ServiciosActivos[contador] = nombreServicios[i];
                contador ++;
            }
        }
        return ServiciosActivos;
    }


    function bajaServicio(string memory _nombreServicio) 
        public UnicamenteAseguradora(msg.sender)
        {
            require(ServicioEstado(_nombreServicio) == true, "El servicio no está disponible");
            MappingServicios[_nombreServicio].EstadoServicio= false;
            emit EventoBajaServicio(_nombreServicio);
        }

    
// ============================= funciones de TOKENS ============================= 

    function balanceOf() public view returns(uint256 tokens){
        return token.balanceOf(Insurance);
    }

    function generarTokens(uint _numTokens) 
        public UnicamenteAseguradora(msg.sender)
    {
        token.increaseTotalSupply(_numTokens);
    }

    function compraTokens(address _asegurado, uint _numTokens) 
        public payable UnicamenteAsegurado(_asegurado)
    {
        uint256 Balance = balanceOf();
        require(_numTokens >= Balance, "Compra un numero de tokens inferior");
        require(_numTokens > 0, "Compra numero positivo de Tokens");
        token.transfer(msg.sender,_numTokens);
        emit EventoComprado(_numTokens);
    }


// ============================= ============================= =============================
// ============================= SMART CONTRACT ASEGURADO ============================= 
// ============================= ============================= =============================
contract InsuranceHealthRecord is OperacionesBasicas{

    enum Estado {alta,baja}

    struct Owner {
        address direccionPropietario;
        uint saldoPropietario;
        Estado estado;
        address insurance;
        address payable aseguradora;
    }

    Owner propietario;

    constructor (address _owner, IERC20 _token, address _insurance, address payable _aseguradora) public{
        propietario.direccionPropietario = _owner;
        propietario.saldoPropietario = 0;
        propietario.estado = Estado.alta;
        propietario.tokens = _token;
        propietario.insurance = _insurance;
        propietario.aseguradora = _aseguradora;
    }

// Servicios solicitados PENDIENTES por el Asegurado
    struct ServiciosSolicitados{
        string nombreServicio;
        uint256 precioServicio;
        bool estadoServicio;
    }

// Servicios solicitados APROBADOS por el Laboratorio
    struct ServiciosSolicitadosLab{
        string nombreServicio;
        uint256 precioServicio;
        address direccionLaboratorio;
    }

    mapping (string => ServiciosSolicitados) historialAsegurado;
    ServiciosSolicitadosLab[] historialAseguradoLaboratorio;

// Eventos ---------------------------------------------------------------
    event EventoSelfDestruct (address);
    event EventoDevolverTokens (address, uint256);
    event EventoServicioPagado (address, string, uint256);
    event EventoPeticionServicioLab (address, address, string);

// Modificadores ---------------------------------------------------------------
    modifier UnicamentePropietario(address _direccion){
        require(_direccion == propietario.direccionPropietario, "No eres el asegurado de la Poliza");
        _;
    }

// funciones ---------------------------------------------------------------
    function HistorialAseguradoLaboratorio() public view returns (ServiciosSolicitadosLab [] memory){
        return historialAseguradoLaboratorio;
    }

    function HistorialAsegurado(string memory _servicio) public view returns (string memory nombreServicio, uint precioServicio){
        return (historialAsegurado[_servicio].nombreServicio,historialAsegurado[_servicio].precioServicio);
    }

    function ServicioEstadoAsegurado(string memory _servicio) public view returns (bool){
        return (historialAsegurado[_servicio].estadoServicio);
    }

    function darBaja() public UnicamentePropietario(msg.sender) {
        emit EventoSelfDestruct(msg.sender);
        // DESTRUIR EL CONTRATO
        selfdestruct(msg.sender);
    }


// FUNCIONES laboratorio ---------------------------------------------------------------
    function peticionServicio(string memory _servicio) 
    public UnicamentePropietario(msg.sender) 
    {
        require(InsuranceFactory(propietario.insurance).ServicioEstado(_servicio)== true, "Servicio no disponible");
        uint256 pagoTokens = InsuranceFactory(propietario.insurance).getPrecioServicio(_servicio);
        require(pagoTokens <= balanceOf(),"Necesitas mas tokens para este servicio");

        // Transferencia
        propietario.tokens.transfer(propietario.aseguradora, pagoTokens);
        historialAsegurado[_servicio] = ServiciosSolicitados(_servicio,pagoTokens,true);
        emit EventoServicioPagado(msg.sender,_servicio,pagoTokens);

    }

    function peticionServicioLab(address _direccionLab, string memory _servicio) 
    public payable
    UnicamentePropietario(msg.sender) 
    {
        Laboratorio contratoLab = Laboratorio(_direccionLab);

        // Transaccion en ethers no en TOKENS
        require(msg.value == contratoLab.ConsultarPrecioServicio(_servicio) * 1 ether,"NO TIENES ETHER SUFICIENTE");

        // si tenemos suficiente ETHERS
        contratoLab.DarServicio(msg.sender, _servicio);

        // Pagar
        payable(contratoLab.DireccionLab()).transfer(contratoLab.ConsultarPrecioServicio(_servicio)* 1 ether);

        // Servicios historial
        historialAseguradoLaboratorio.push(
            ServiciosSolicitadosLab(
                _servicio,
                contratoLab.ConsultarPrecioServicio(_servicio),
                _direccionLab));
        
        emit EventoPeticionServicioLab(_direccionLab,msg.sender,_servicio);
    }
// ============================= funciones de TOKENS del ASEGURADO ============================= 

    function balanceOf() 
    public view  UnicamentePropietario(msg.sender) 
    returns(uint256 _balance){
        return (propietario.token.balanceOf(address(this)));
    }

    function  CompraTokens(uint _numTokens)
    payable public UnicamentePropietario(msg.sender) 
    {
        require(_numTokens >0 ,"Compra mas de un Token");

        //calcularPrecioTokens -- está en el archivo Operacionebasicas.sol 
        uint coste=calcularPrecioTokens(_numTokens);

        require(msg.value >= coste,"Numero de Ethers insuficiente");

        uint returnValue = msg.value - coste;
        // solo ahora transfiero.
        msg.sender.transfer(returnValue);
        InsuranceFactory(propietario.insurance).compraTokens(msg.sender,_numTokens);

    }

    function DevolverTokens(uint _numTokens)
    payable public UnicamentePropietario(msg.sender) 
    {
        require(_numTokens >0 ,"No tienes Tokens");
        require(_numTokens <=0 balanceOf(),"No tienes Tokens suficientes");

        //calcularPrecioTokens -- está en el archivo Operacionebasicas.sol 
        uint coste=calcularPrecioTokens(_numTokens);

        //tokens del Asegurado a la aseguradora
        propietario.tokens.transfer(propietario.aseguradora, _numTokens);
        msg.sender.transfer(coste);

        emit EventoDevolverTokens(msg.sender,_numTokens);
    }

}



// ============================= ============================= =============================
// ============================= SMART CONTRACT LABORATORIO ============================= 
// ============================= ============================= =============================
contract Laboratorio is OperacionesBasicas{
    address public DireccionLab;
    address contratoAseguradora;

    constructor (address _account, address _direccionContratoAseguradora) public{
        DireccionLab = _account;
        contratoAseguradora = _direccionContratoAseguradora;
    }

// structuras ----------------------------------------------------------------------------------

    struct ResultadoServicio{
        string diagnostico_Servicio;
        string codigo_IPFS;
    }

    struct ServicioLab{
        string nombreServicio;
        uint precio;
        bool enFuncionamiento;
    }

// MAPPINGS - ARRAYS ----------------------------------------------------------------------------------

    mapping (address => string) public ServicioSolicitado;
    mapping (address => ResultadoServicio) public ResultadosServiciosLab;
    mapping (string => ServicioLab) public ServiciosLab;

    address[] public PeticionesServicios;
    string [] nombreServiciosLab;

// EVENTOS ----------------------------------------------------------------------------------

    event EventoServiciosFuncionando(string, uint);
    event EventoDarServicio(address, string);

// MODIFICADORES ----------------------------------------------------------------------------------

    modifier UnicamenteLab(address _direccion){
        require(_direccionf == DireccionLab,"No existen permisos para esta funcion");
        _;
    }

// FUNCIONES ----------------------------------------------------------------------------------

    function NuevoServicio(string memory _servicio, uint _precio)
        public UnicamenteLab (msg.sender)
        {
            ServiciosLab[_servicio] = ServicioLab(_servicio,_precio,true);
            nombreServiciosLab.push(_servicio);
            emit EventoServiciosFuncionando(_servicio,_precio);
        }

    function ConsultarServicios() public view returns(string[] memory){
        // TODO: devolver solo servicios disponibles
        return nombreServiciosLab;
    }
    
    function ConsultarPrecioServicio(string memory _servicio)
    public view returns(uint){
        return ServiciosLab[_servicio].precio;
    }

    function DarServicio(address _asegurado, string memory _servicio)
    public{
        //Requerir que la persona está asegurada.
        InsuranceFactory IF = InsuranceFactory(contratoAseguradora);
        IF.FuncionUnicamenteAsegurados(_asegurado);

        //ver si servicio disponible
        require(serviciosLab[_servicio].enFuncionamiento == true,"Servicio NO disponible");

        // asignar al asegurado el servicio
        ServicioSolicitado[_asegurado] = _servicio;
        PeticionesServicio.push(_asegurado);

        emit EventoDarServicio(_asegurado, _servicio);
    }



// ============================= funciones de TOKENS del LABORATORIO ============================= 


}