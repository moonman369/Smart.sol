pragma solidity ^0.6.0;

contract Functions{

    address public owner;

    constructor() public {
        owner = msg.sender;
    }

    mapping (address => uint) public balanceReceived;

    function receiveMoney() public payable {
        balanceReceived[msg.sender] = msg.value;
    }

    receive() external payable {
        receiveMoney();
    }

    fallback() external payable {
        receiveMoney();
    }

    function weiToEth(uint _amountWei) public pure returns(uint) { //
        return _amountWei / 1 ether;
    }

    function withdrawMoney (address payable _to, uint _amount) public {
        require (_amount <= balanceReceived[msg.sender], "OwnerAuthException");
        balanceReceived[msg.sender] -= _amount;
        _to.transfer(_amount);
    }
}