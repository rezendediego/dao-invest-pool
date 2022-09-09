// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.9;

import "../node_modules/@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract BonusCoin is ERC20 {
    uint256 bonusAmount;
    address public admin;
    
    constructor(uint256 _bonusAmount) ERC20("BON", "Bonus Coin") {
      admin = msg.sender;
      bonusAmount = _bonusAmount;
     _mint(admin, bonusAmount*10**18);   
     
    }

    function getAddress() external view returns(address){
      return address(this);
    }
   
}
