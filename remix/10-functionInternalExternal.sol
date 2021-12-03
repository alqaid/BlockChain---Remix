pragma solidity >=0.4.4 <0.9.0;

/* 
************** ************** ************** ************** **************
************** ***** FUNCIONES  INTERNAL EXTERNAL ********* ************
************** ************** ************** ************** **************  
    
--- 
    function f () [] [] [] [] ([]) * {}

    internal: parecido a a private solo desde el contratos
    external: solo puede ser llamado externamente * cuesta menos gas



*/

contract Comida{

    struct plato{
        string nombre;
        string ingredientes;
        uint tiempo;
    }

    plato[] platos;    
    mapping(string => string) Ingredientes;

    function nuevoPlato(string memory _nombre, string memory _ingredientes, uint _tiempo) internal{
        platos.push(plato(_nombre,_ingredientes, _tiempo));
        Ingredientes[_nombre] = _ingredientes;
    }

    function losIngredientes(string memory _nombre) internal view returns(string memory) {
        return Ingredientes[_nombre];
    }

}

contract Sandwitch is Comida{
    //Es INTERNAL no la podemos llamar desde Sandwitch
    function nuevoSandwitch(string memory _ingredientes, uint _tiempo) external{
        nuevoPlato("Sandwitch", _ingredientes,_tiempo);
    }

    //Es INTERNAL
    function verIngredientes() external view returns (string memory) {
        return losIngredientes("Sandwitch");
    }


}