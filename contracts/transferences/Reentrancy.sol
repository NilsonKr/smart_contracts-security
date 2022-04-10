//SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;


contract ReentrancyVictim {
  mapping (address => uint256)  private balances;

  function withdrawal () external {
     uint256 balance = balances[msg.sender];

     bool result = payable(msg.sender).send(balance);

     require(result, "Failed to withdraw");

     balances[msg.sender] = 0;
  }
}


//Recursive call to the function in order to empty the contracts funds
contract AttackContract {
  address private victimContract;

  constructor(address _victimContract) {
    victimContract = _victimContract;
  }

  receive() external payable {
    victimContract.call(abi.encodeWithSignature("withdrawal"));
  }
}


contract SafeReentrancy {
  mapping (address => uint256)  private balances;
  uint256 private constant GAS_LIMIT = 10000;

  function withdrawal () external {
     uint256 balance = balances[msg.sender];
     //Update state after the transaction
     balances[msg.sender] = 0;

    //Set a prevention gas limit;
     (bool result,) = msg.sender.call{value: balance, gas: GAS_LIMIT}("");

     require(result, "Failed to withdraw");
  }
}