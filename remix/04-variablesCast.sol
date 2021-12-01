pragma solidity >=0.4.4 <0.9.0;


contract cast{ 

    uint8 vuint8 = 80;   // rango:  0 -- 255
    uint64 vuint64 = 6000;
    uint vuint256 = 256000;

    int8 vint8 = -128;   // rango: -128 -- +127
    int120 vint120 = 111222;
    int vint256 = 333222111;

    // CAST UINT -- UINT
    uint64 public cast1 = uint64(vuint8);
    uint64 public cast2 = uint64(vuint256);    

    // CAST INT -- INT
    int public cast3 = int(vint120);
    int120 public cast4 = int120(vint256);


    // ojo si el tipo destino es más pequeño. 
    //       -24    <=   1000
    int16 var0 = 1000;
    int8 public cast5 = int8(var0);

    // CAST UINT <-- INT  
    //       136    <=   -120
    //       246    <=    -10
    int8 var1 = -10;
    uint8 public cast6 = uint8(var1);


    // CAST   INT <-- UINT
    //       50   <=   50
    uint8 var2 = 50;
    int8 public cast7 = int8(var2);

    // ojo si te pasas del dato. int8 es mas pequeño que uint8
    //       -1   <=   255
    uint8 var3 = 255;
    int8 public cast8 = int8(var3);

    function transformar(int _v) public pure returns(int8){
        return int8(_v);
    }
}