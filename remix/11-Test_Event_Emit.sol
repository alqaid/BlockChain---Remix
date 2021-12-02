pragma solidity >=0.4.4 <0.9.0;

// Tests
// eventos emitidos dejan en el log los movimentos.

contract Eventos{

    // Events
    event nombre_Evento0();
    event nombre_Evento1(string _nombrePersona);
    event nombre_Evento2(string _nombrePersona, uint _edad);
    event nombre_Evento3(string,uint,address,bytes32);

    // Emits

    function EmitirEvento1(string memory _nombrePersona)public{
        emit nombre_Evento0();
        emit nombre_Evento1(_nombrePersona);

    }

    function EmitirEvento2(string memory _nombrePersona, uint _edad)public{

        emit nombre_Evento2(_nombrePersona,_edad);

    }



    function EmitirEvento3(string memory _nombrePersona, uint _edad )public{
        emit nombre_Evento0();
        
        bytes32 hash_id= keccak256(abi.encodePacked(_nombrePersona,_edad,msg.sender));
        emit nombre_Evento3(_nombrePersona,_edad,msg.sender,hash_id);

    }
}