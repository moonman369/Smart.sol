pragma solidity ^0.7.0;

contract Ownership {
    address owner;

    constructor () public{
        owner = msg.sender;
    }

    modifier ownerCheck {
        require (msg.sender == owner, "OwnerAuthException");
        _;
    }

}