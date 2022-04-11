//SPDX-License-Identifier:  MIT
pragma solidity ^0.8.0;

contract Desafio {
    //Access control to avoid store sensitive data in non-private variables
    address public owner;
    mapping(address => uint) public balances;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner {
      require(msg.sender == owner, "You're not allowed");
      _;
    }

    function min(uint amount) public onlyOwner {
        balances[msg.sender] += amount;
    }

    function depositar() public payable{
        balances[msg.sender] += msg.value;
    }

    function retirar() public {
        require(balances[msg.sender] > 0, "You should have balance");
        //Avoiding reentrancy attacks
        uint256 balance = balances[msg.sender];
        balances[msg.sender] = 0;
        
        (bool result, ) = msg.sender.call{value:balance, gas: 100000}("");

        if(!result) revert("Transaction failed to execute");
    }
}