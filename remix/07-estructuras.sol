// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.4 <0.9.0;

// ==============================
// Estructuras:
// ==============================
/* 
    
    struct <nombre estructura>{
        <tipo de dato> <nombre variable>;
        <tipo de dato> <nombre variable>;
        <tipo de dato> <nombre variable>;
        ....
    }


----- Crear variable de tipo struct

    <nombre estructura> <nombre variable>;


----- Instanciar
    <nombre variable> = (<dato1>,<dato2>,<dato3>,...);

*/ 


contract estructura{

    // Cliente de una página web
    struct cliente{
        uint id;
        string nombre;
        string dni;
        string mail;
        uint movil;
        uint tarjeta_credito;
        uint numero_secreto;
    }


    cliente cliente_1 = cliente(1,"Angel","32.432.433", "correo@gmail.com",965323232,324234123412,1234);

// producto de una página web
    struct producto{
        string nombre;
        uint precio;
    }

    producto producto_1 = producto("Movil Samsung J5",300);

 
    
}