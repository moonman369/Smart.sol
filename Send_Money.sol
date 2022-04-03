pragma solidity ^0.5.13;

contract contractUtil{

    //receives money from an address to the smart contract
    uint public balReceived;
    address public from;
    function receiveMoney() public payable {
        //msg is a global variable and value stores the value in wei that was transacted
        balReceived = msg.value;
        from = msg.sender;
    }

    //check balance of the smart contract
    uint conBal;
    function getBal() public view returns(uint){
        return address(this).balance;
    }

    //send money
    function sendMoney(/*address ad*/) public{
        address payable to = msg.sender;
        to.transfer(this.getBal());
    }

    function transferMoney(address payable to) public{
        to.transfer(this.getBal());
    }
}