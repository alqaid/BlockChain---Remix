pragma solidity >=0.4.4 <0.9.0;


/* 
     
************** ************** ************** ************** **************
************** ***** MULTIPLES CONTRATOS - HERENCIA ********* ************
************** ************** ************** ************** **************  
    contract <nombre 1> {
        ... }
     
    contract <nombre 2> is <nombre 1>{
        ... }

*/


contract Banco{

    struct Cliente{
        string nombre;
        address direccion;
        int dinero;  // usamos int ya que al comparar sin signo se producen errores
    }

    // maping el nombre con el tipo de dato

    mapping (string => Cliente) ListaClientes;


    // funcion para dar de alta Clientes con 0 euros
    // INTERNAL -- Debe ser accesible para el ContratoCliente pero no publica
    function nuevoCliente(string memory _nombre) internal {
        ListaClientes[_nombre] = Cliente(_nombre,msg.sender, 0);
    }
}

// Segundo contrato que hereda del banco
 
contract ContratoCliente is Banco{

    // alta Cliente
    function  AltaCliente(string memory _nombre) public {
        nuevoCliente(_nombre);
    }

    // ingresar dinero
    function  IngresarCliente(string memory _nombre, int _cantidad) public {
        ListaClientes[_nombre].dinero = ListaClientes[_nombre].dinero + _cantidad;
    }

    // Retirar dinero
    function  RetirarCliente(string memory _nombre, int _cantidad) public returns(bool){
        bool flag = true;
        int resta =  ListaClientes[_nombre].dinero   - _cantidad;
        if (resta >= 0){
            ListaClientes[_nombre].dinero = ListaClientes[_nombre].dinero - _cantidad;
        }else{
            flag = false;
        }
        return flag;
    }

    // Consultar  dinero
    function  ConsultarCliente(string memory _nombre) public view returns(int){
       return ListaClientes[_nombre].dinero;
    }
}