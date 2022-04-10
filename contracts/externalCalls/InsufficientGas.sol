//SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;


//Example of a bad handling external calls 
contract InsufficientGasBadHandle {
  uint256 public counter = 0;

  function executeOp(address _contract) external {
    (bool result,) = _contract.call(abi.encodeWithSignature("someFn()"));
    counter++;
  }
}

contract InsufficientGasGoodHandle {
  uint256 public counter = 0;

  function executeOp(address _contract) external {
    (bool result,) = _contract.call(abi.encodeWithSignature("someFn()"));

    if(!result){
      revert("External execution failed");
    }else {
      counter++;
    }
  }
}