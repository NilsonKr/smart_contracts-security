//SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract TestDeploy {
  uint256 private secretNumber;

  constructor (uint256 num) {
    secretNumber = num;
  }
}
