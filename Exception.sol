pragma solidity ^0.5.3;

contract Exception{

    mapping (address => uint) public balanceReceived;

    function receiveMoney() public payable{
        balanceReceived[msg.sender] += msg.value;
    }

    function withdrawMoney(address payable _to, uint amount) public {
        require(amount <= balanceReceived[msg.sender], "InsufficientBalanceException");
        //assert(balanceReceived[msg.sender] >= balanceReceived[msg.sender] - amount);
        balanceReceived[msg.sender] -= amount;
        _to.transfer(amount);
    }
}