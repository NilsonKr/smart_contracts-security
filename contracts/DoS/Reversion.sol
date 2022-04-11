//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


/* The contract will set a majorBid and the current bidder 
 * Every time when someone bet a new major bid will return the current bid to the last bidder 
 */
contract DoSReversion {
  uint256 public majorBid;
  address payable public currentBidder;

  function bet() external payable {
    require(msg.value > majorBid, "Bet has to be major than the current");

    require(currentBidder.send(majorBid));

    currentBidder = payable(msg.sender);
    majorBid = msg.value;
  }
}


contract AttackDoS { 

  //When the contract is the current bidder and arrives someone else
  //to try to bet a new ammount will stuck in this reversion
  //the bet contract wont be able to set a new current bidder and major bid  
  receive () external payable {
    revert();
  }
}


