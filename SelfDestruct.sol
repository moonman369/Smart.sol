pragma solidity ^0.6.5;
contract Self_destruct{
    address public owner;
    constructor () public {
         owner = msg.sender;
     }

    function receiveEth() public payable {}

    fallback () external payable{
        receiveEth();
    }

    function get_balance () public view returns (uint){
        return address(this).balance;
    }

    function withdrawAllMoney (address payable _to, uint _amt) public {
        require (_amt <= get_balance());
        _to.transfer(_amt);
    }

    function destroy_contract (address payable beneficiary) public {
        selfdestruct(beneficiary);
    }
}