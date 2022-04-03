pragma solidity ^0.5.0;
contract StartStopUpdate{

    address owner;
    constructor() public{
        owner = msg.sender;
    }
    //receiving money into the contract
    function sendMoney () public payable {}
    
    //getting total contract balance
    function getContractBalance() public view returns (uint) {
        return address(this).balance;
    }

    //pausing the contract
    //funds can be sent to the contract but not withdrawn
    bool public paused;
    function setPaused(bool _paused) public {
        require (msg.sender == owner, "OwnerAuthException");
        paused = _paused;
    }

    //withdraw all money to the owner + pause check
    function withdraAllMoney (address payable _to) public {
        require (msg.sender == owner, "OwnerAuthException");
        require (!paused, "Contract is currently paused, try again later");
        _to.transfer(address(this).balance);
    }

    //destroy the contract
    function destroyContract (address payable _to) public {
        require (msg.sender == owner, "OwnerAuthException");
        selfdestruct(_to);
    }
}