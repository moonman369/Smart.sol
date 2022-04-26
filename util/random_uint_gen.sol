pragma solidity ^0.8.0;
 contract RandomUintGen {
    uint public randNonce;
    uint public random; 

    function incRandNonce() internal {
        randNonce++;
    }

     function randomGen () public{
        incRandNonce();
        random = uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, randNonce)));
     }
 }