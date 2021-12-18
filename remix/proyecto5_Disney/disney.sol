// SPDX-License-Identifier: MIT
pragma solidity >=0.4.4 <0.7.0;
pragma experimental ABIEncoderV2;
import "./ERC20.sol";

// SAFEMATH NO hace falta si no se usa aqui solo dentro de ERC20


contract Disney{

 // ============================= variables globales =============================    

    ERC20Basic private token;       // instancia a este contrato de los Tokens
    address payable  public owner;  // Dirección de DISNEY

    constructor () public {

        // instanciar el número de tokens 
        token = new ERC20Basic(1000);
        owner = msg.sender;

        FnuevaAtraccion("StarWars",2);
        FnuevaAtraccion("La Noria",3);
        FnuevaAtraccion("El Pulpo",2);
        FnuevaAtraccion("Show",5);

        FnuevoMenu("Hamburguesa",5);
        FnuevoMenu("Hotdog",4);
        FnuevoMenu("Infantil",3);
        FnuevoMenu("Vegano",10);
    }

 // ============================= STRUCTS =============================   

    struct cliente {
        uint token_comprados;
        string [] atracciones_disfrutadas;
    }

 // ============================= MAPPINGS =============================      

    mapping (address => cliente) public Clientes;

 // ============================= MODIFIERS =============================  

    modifier Unicamente(address _direccion){
        require(_direccion == owner, "No tienes permiso para ejecutar esta function");
        _;
    }
    
 // ============================= GESTION DE TOKENS =============================  

 // Función para establecer precio del Token. 
 // Conversión de token a eth.

    function PrecioToken(uint _numTokens) internal pure returns (uint){
        // CADA 100 tokens comprados  cuesta 0,0001
        return _numTokens * (0.000001 ether);
    }   

 // Función para comprar Tokens
 // usamos msgvalue para capturar los eth a comprar.

    function CompraTokens(uint _numTokens) public  payable{
        uint coste = PrecioToken(_numTokens);
        require (msg.value >= coste, "Compra menos Tokens o paga con mas ethers");

        // obtener la diferencia de lo que paga
        uint returnValue = msg.value - coste;

        // Disney retorna la cantidad de ethers al cliente
        msg.sender.transfer(returnValue);

        // Balance de tokens disponible
        uint Balance = f_balance();
        require(_numTokens <= Balance,"Compra un numero menor de Tokens");

        //cargar tokens a la cuenta del cliente
        token.transfer(msg.sender,_numTokens);

        // Almacenr en un registro.
        Clientes[msg.sender].token_comprados += _numTokens;
    }   

 // Función balance del contrato  DISNEY
  function f_balance() public view returns (uint){
    //Retornamos el número de tokens del contrato.
    //address(this) Es la dirección del contrato.
      return token.balanceOf(address(this));
   } 

 // número de tokens disponibles
    function MisTokens() public view returns (uint){
       return token.balanceOf(msg.sender);
    } 

 // Generar mas Tokens
    function GeneraTokens(uint _numTokens) public Unicamente(msg.sender){
        token.increaseTotalSuply(_numTokens);
    } 


 function RegalarTokens(address _usuario,uint _numTokens) public Unicamente(msg.sender){
        

        // Balance de tokens disponible
        uint Balance = f_balance();
        require(_numTokens <= Balance,"Compra un numero menor de Tokens");

        //cargar tokens a la cuenta del cliente
        token.transfer(_usuario,_numTokens);

        // Almacenr en un registro.
        Clientes[_usuario].token_comprados += _numTokens;
    }  
// ============================= GESTION DE DISNEY =============================  

// ============================= GESTION DE DISNEY EVENTOS =============================  

   event disfruta_atraccion(string,uint,address);
   event nueva_atraccion(string, uint);
   event baja_atraccion(string);

   event nuevo_menu(string, uint);
   event comprar_comida(string, uint,address);

// ============================= GESTION DE DISNEY ESTRUCTURAS =============================  

   struct atraccion{
      string nombre_atraccion;
      uint precio_atraccion;
      bool estado_atraccion;  // true atracción en uso
   }

   struct menu{
      string nombre_menu;
      uint precio_menu;
   }
// ============================= GESTION DE DISNEY mapping =============================  

   mapping(string => atraccion) public MappingAtracciones;
   mapping(address => string[]) MappingHistorialAtracciones;

   mapping(string => menu) public MappingMenu;
   mapping(address => string[]) MappingHistorialMenus;
// ============================= GESTION DE DISNEY arrays =============================  

   string [] ArrayAtracciones;

   string [] ArrayMenus;

// ============================= GESTION DE DISNEY funciones =============================  

   // Atracciones
   // Star Wars -> 2 Tokens
   // Toy Story -> 5 Tokens
   // Piratas caribe -> 8 Tokens




   // Solo ejecutable por DISNEY
   function FnuevaAtraccion(string memory _nombreAtraccion, uint _precio) public Unicamente(msg.sender){
      // Alta de  nuevas atracciones
      MappingAtracciones[_nombreAtraccion] = atraccion(_nombreAtraccion,_precio,true);
      // almacenar en un array el nombre de la atracción
      ArrayAtracciones.push(_nombreAtraccion);

      // Emitimos el evento  para la nueva atracción
      emit nueva_atraccion(_nombreAtraccion,_precio);
   } 

   // Solo ejecutable por DISNEY
   function FbajaAtraccion(string memory _nombreAtraccion) public Unicamente(msg.sender){
      // cambiamos el estado de la atracción
      MappingAtracciones[_nombreAtraccion].estado_atraccion= false;

      // Informamos a la red
      emit baja_atraccion(_nombreAtraccion);
   }

   // Publica para todos
   function FAtraccionesDisponibles() public view returns(string [] memory){
      return ArrayAtracciones;
   }

   // Publica PAGAR para subir
   function FSubirAtraccion(string memory _nombreAtraccion) public {
      // Verifica si Está disponible
      require(MappingAtracciones[_nombreAtraccion].estado_atraccion == true,
         "Atraccion no disponible"
         );
      
      // Preguntamos  que vale
      uint tokens_atraccion = MappingAtracciones[_nombreAtraccion].precio_atraccion;

      // verificamos si el cliente tiene tokens suficientes
      require(tokens_atraccion <= MisTokens(),
         "Necesitas comprar mas tokens");


      // Transferencia de TOKENS
      /* 
         Necesario una funcion transferencia_disney en ERC20.sol
         al usar transfer a pelo coge la dirección del contrato

         Transferimos del address del cliente  msg.sender
         al address del contrato: address(this)
      */

      token.transferencia_disney(msg.sender,address(this),tokens_atraccion);
      

      // Almacenar  Historial del cliente
      MappingHistorialAtracciones[msg.sender].push(_nombreAtraccion);

      
      // emision del evento para disfrutar atracción
      emit disfruta_atraccion(_nombreAtraccion,tokens_atraccion, msg.sender);


   }

 // Publica para todos
   function FHistorialAtracciones() public view returns(string [] memory){
      // Ver el historial
      return MappingHistorialAtracciones[msg.sender];
   }


// ============================= GESTION DE DISNEY funciones Menu=============================  

 // Solo ejecutable por DISNEY
   function FnuevoMenu(string memory _nombreMenu, uint _precio) public Unicamente(msg.sender){
      // Alta de  nuevas atracciones
      MappingMenu[_nombreMenu] = menu(_nombreMenu,_precio);
      // almacenar en un array el nombre de la atracción
      ArrayMenus.push(_nombreMenu);

      // Emitimos el evento  para la nueva atracción
      emit nuevo_menu(_nombreMenu,_precio);
   } 

   // Publica para todos
   function FMenusDisponibles() public view returns(string [] memory){
      return ArrayMenus;
   }


// Publica PAGAR para subir
   function FPedirComida(string memory _nombreMenu) public {
      
      // Preguntamos  que vale
      uint tokens_ = MappingMenu[_nombreMenu].precio_menu;

      // verificamos si el cliente tiene tokens suficientes
      require(tokens_ <= MisTokens(),
         "Necesitas comprar mas tokens");


      // Transferencia de TOKENS
      /* 
         Necesario una funcion transferencia_disney en ERC20.sol
         al usar transfer a pelo coge la dirección del contrato

         Transferimos del address del cliente  msg.sender
         al address del contrato: address(this)
      */

      token.transferencia_disney(msg.sender,address(this),tokens_);
      

      // Almacenar  Historial del cliente
      MappingHistorialMenus[msg.sender].push(_nombreMenu);

      
      // emision del evento para disfrutar atracción
      emit comprar_comida(_nombreMenu,tokens_, msg.sender);


   }


   
 // Publica para todos
   function FHistorialMenus() public view returns(string [] memory){
      // Ver el historial
      return MappingHistorialMenus[msg.sender];
   }
// ============================= OTRAS funciones =============================  

 // Publica para todos
   function FDevolverTokens(uint _numTokens) public payable{
      // Tokens son positivos y tienes tantos como quieres devolver
      require(_numTokens>0,"NO tienes tokens");
      require(_numTokens <= MisTokens(),"NO tienes suficientes tokens");

      // Devolver 
       token.transferencia_disney(msg.sender,address(this),_numTokens);

      // Devolvemos los eths.
      msg.sender.transfer(PrecioToken(_numTokens));

   }

}
