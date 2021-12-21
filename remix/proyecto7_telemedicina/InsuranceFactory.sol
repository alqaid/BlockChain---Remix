// SPDX-License-Identifier: MIT
pragma solidity >=0.4.4 <0.7.0;
pragma experimental ABIEncoderV2;
import "./OperacionesBasicas.sol";
import "./ERC20.sol";

// FActoria de Seguros

contract InsuranceFactory is OperacionesBasicas{

    constructor () public {
        token = new ERC20Basic(100);
    }

    ERC20basic private token;

}