pragma solidity ^0.7.0;

import "./Ownership.sol";
import {Ownership as Own} from "./Ownership.sol";


contract MainContract is Own {
    uint txPrice = 1e12; //1 finney = 10^-3 ether

    mapping(address=>uint) public txBalance;

    event txSent(address _from, address _to, uint amount);

    constructor() public {
        txBalance[owner] = 1000000;
    }

    function mintTx() public ownerCheck{
        txBalance[owner] += 1000;
    }

    function burnTx() public ownerCheck{
        txBalance[owner] -= 1000;
    }

    function txToEth(uint _txAmount) public view returns(uint) {
        return _txAmount*txPrice;
    }

    function buyTx() public payable{
        require((txBalance[owner]*txPrice) / msg.value > 0, "Insufficient tokens in existence.");
        txBalance[msg.sender] += msg.value / txPrice; 
    }

    function sendTx(address _to, uint _txAmount) public returns (bool) {
        require (_txAmount <= txBalance[msg.sender], "Insufficent token balance.");
        assert (txBalance[_to] + _txAmount >= txBalance[_to]);
        assert (txBalance[msg.sender] - _txAmount <= txBalance[msg.sender]);

        txBalance[msg.sender] -= _txAmount;
        txBalance[_to] += _txAmount;

        emit txSent(msg.sender, _to, _txAmount);
        return true;
    }

    // function sellTx(uint _txAmount) public {
    //     require (_txAmount <= txBalance[msg.sender]);
    //     txBalance[msg.sender] -= _txAmount;
    //     address payable _to = msg.sender;
    //     _to.transfer(_txAmount/1000);
    // }

}