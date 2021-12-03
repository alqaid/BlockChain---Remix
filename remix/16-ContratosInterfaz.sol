pragma solidity >=0.4.4 <0.9.0;

/* 
************** ************** ************** ************** **************
************** ***** MULTIPLES CONTRATOS - INTERFAZ ********* ************
************** ************** ************** ************** **************  
    
---Declarar Interfaz 
    contract interfaz{
        
        // copiamos los nombres de las funciones con las que queremos interactuar
        function <nombre> <parametors>  ;

--- COMO USAR
    //1. Declara puntero
    
    <NOMBRE_INTERFAZ> <NOMBRE_PUNTERO> = <NOMBRE_INTERFAZ>(direccion_contrato);

    //2. Usar  el puntero

    <nombre_puntero>.<funcion> (<parametros>);

    }