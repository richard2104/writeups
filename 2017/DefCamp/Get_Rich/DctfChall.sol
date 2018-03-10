pragma solidity ^0.4.4;

contract Owned {
    address public owner;

    function Owned() {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner);
        _; // 이 뒤로 나중에 하라는 뜻
    }

    function transferOwnership(address newOwner) onlyOwner {
        owner = newOwner;
    }
}

contract DctfChall is Owned {
	string public name;
	string public symbol;
	uint8 public decimals;

	mapping (address => uint256) public balanceOf;

	modifier onlyWithMoney(uint256 amount) {
		require(balanceOf[msg.sender]>= amount);
		_;
	}

	function DctfChall(uint256 _supply, string _name, string _symbol, uint8 _decimals) {
		if(_supply == 0) _supply = 13333337; //ERC-20 token 총개수

		balanceOf[msg.sender] = _supply;
		name                  = _name;
		symbol                = _symbol;
		decimals              = _decimals;
	}

	function invest(address to) payable { //remix 롭스텐테스트넷에 invest(contract주소)하니까 돈보내짐
		require(msg.value > 0);
		balanceOf[to] += msg.value;
		Transfer(msg.sender, to, msg.value);
	}

	function transferFrom(address to, uint256 amount) { //token을 transfer
		require(amount > 0);
		require(balanceOf[msg.sender] >= amount);

		balanceOf[msg.sender] -= amount;
		balanceOf[to]         += amount;
		Transfer(msg.sender, to, amount);
	}

	function getBalance(address to) returns (uint256){
		return balanceOf[to];
	}

	function withdraw(uint256 amount) onlyWithMoney(amount) { //modifier. 돈있는사람만댐벼라
		require(amount > 0);
		msg.sender.call.value(amount)(); //이 코드가 먼저 존재해서 만약 withdraw()를 재귀적으로 호출하면
						 //fallback함수 끝날때까지는 마이너스 안됨
		balanceOf[msg.sender]-=amount;
		Withdraw(msg.sender, amount);
	}

	function getContractAddress() constant returns (address){ //Contract의 주소 반환
	    return this;
	}

	function() payable { }
	
	// event는 블록체인의 log entries에 사용되는거니까 걱정ㄴㄴ
	event Transfer(address indexed from, address indexed to, uint256 value);
	event Withdraw(address indexed to, uint256 value);
}

