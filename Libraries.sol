pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/utils/math/SafeMath.sol";

 contract Libraries{
    mapping (address => uint) public tokenBalance;
    address public owner;

    using SafeMath for uint;

    constructor () public {
        owner = msg.sender;
        tokenBalance[owner] = 1;    
    }

    function sendToken (address _to, uint _amount) public returns (bool) {
        tokenBalance[msg.sender] = tokenBalance[msg.sender].sub(_amount);
        tokenBalance[_to] += _amount;

        return true;
    }
 }