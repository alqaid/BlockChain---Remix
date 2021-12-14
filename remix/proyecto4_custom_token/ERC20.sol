// SPDX-License-Identifier: MIT
pragma solidity >=0.4.4 <0.7.0;
pragma experimental ABIEncoderV2;
import "./SafeMath.sol";


// Interface para los token
interface IERC20{

    //Metodo devuelve cantidad de tokens
    function totalSupply() external view returns (uint256);

    //Devuelve la cantidad de tokens para una dirección indicada
    function balanceOf(address account) external view returns (uint256);


    //Devuelve el número de tokens que el spender podrá gastar en nombre del propietario
    // allowance permiso
    function allowance(address owner, address spender) external view returns (uint256);


    // Devuelve un valor resultado de la operación transferencia de un numero de tokens
    // 
    function transfer(address recipient, uint256 amount) external returns (bool);

    // Devuelve un valor resultado de la operacion de gasto
    function approve(address spender, uint256 amount) external returns (bool);

     // Devuelve un valor resultado de la operacion de paso de una cantidad de tokens usando allowance
    function transferFrom(address sender,address recipient, uint256 amount) external returns (bool);

    // Evento emitido cuando una cantidad de tokens pasen de un origen a un destino
    event Transfer(address indexed from, address indexed to, uint256 value);

    // Evento emitido cuando se establece una asignación con el metodo allowance
    event Approval(address indexed owner, address indexed spender, uint256 value);
}


contract ERC20Basic is IERC20{

// ============================= NUESTRA CRIPTOMONEDA =============================

//  al desplegar para 1000 tokens con 2 decimles, desplegar 100000 (5 ceros)
    string public constant name = "ERC20BlockchainAZ";
    string public constant symbol = "ALQ";
    uint8 public constant decimals = 2 ; 

// ============================= EVENTOS =============================

    event Transfer(address indexed from, address indexed to, uint256 tokens);
    event Approval(address indexed owner, address indexed spender, uint256 tokens);

    // las funciones serán válidas.
    using SafeMath for uint256;

// ============================= mappings =============================
    mapping (address => uint) balances;

    // distribuir la moneda.
    mapping (address => mapping( address => uint)) allowed;

    // numero total de tokens.
    uint256 totalSupply_; 


// ============================= CONSTRUCTOR =============================

constructor  (uint256 initialSupply) public{
    totalSupply_ = initialSupply;
    balances[msg.sender] = totalSupply_;
}

// ============================= FUNCIONES BASICAS DE NUESTRA CRIPTOMONEDA =============================
    function totalSupply() public override view returns (uint256){
        return totalSupply_;
    }

    // Increment totalsuply con un numero de tokens
    function increaseTotalSupply(uint newTokensAmount) public{
        totalSupply_ += newTokensAmount;
        balances[msg.sender] += newTokensAmount;
    }

    // token de una dirección
    function balanceOf(address tokenOwner) public override  view returns (uint256){
        return balances[tokenOwner];
    }

    // Cuantos tokens tiene Permitido gastar en nombre de otro
    function allowance(address owner, address delegate) public override  view returns (uint256){
         return allowed[owner][delegate];
    }

    // Transfiero tokens a otro
    function transfer(address recipient, uint256 numTokens) public override returns (bool){
        //verifico si puedo transferir esa cantidad
        require(numTokens <= balances[msg.sender]);
        //Resta segura
        balances[msg.sender] = balances[msg.sender].sub(numTokens);
        //Suma Segura
        balances[recipient] = balances[recipient].add(numTokens);

        // emitir la transferencia AVISAR de ello
        emit Transfer(msg.sender,recipient,numTokens);
        return true;
    }

    // Dar permiso para utilizar X tokens en mi nombre
    function approve(address delegate, uint256 numTokens) public override  returns (bool){
        allowed[msg.sender][delegate] = numTokens;
        emit Approval(msg.sender,delegate,numTokens);
        return true;
    }

    // Transferencia como  intermediario
    function transferFrom(address owner,address buyer, uint256 numTokens) public override  returns (bool){
        // Ver si el propietario dispone de los tokens
        require(numTokens <= balances[owner]);
        // Ver si hay suficientes tokens permitidos para hacer la transacción. Ya que soy intermediario
        require(numTokens <= allowed[owner][msg.sender]);

        // Hacer las transferencias si llego aquí.
        // 1º quito los tokens al propietario
        balances[owner] =balances[owner].sub(numTokens);
        // 2º quitamos la propietariedad de estos tokens que tengo provisionalmente
        allowed[owner][msg.sender] = allowed[owner][msg.sender].sub(numTokens);

        // se los doy al comprador
        balances[buyer] =balances[buyer].add(numTokens);

        // comunicar a toda la red  la transaccion entre ambos
        emit Transfer(owner,buyer,numTokens);
        return true;
    }
}