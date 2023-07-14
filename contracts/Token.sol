// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Token is ERC20 {
    // Initialize contract with 1 million tokens minted to the creator of the contract

 
        ///@notice Constructor to create a Token
        ///@dev The decimals of the token is set to 18 by default
  
    
    constructor() ERC20("Token", "TKN") {
        _mint(msg.sender, 1000000 * 10 ** decimals());
    }
}