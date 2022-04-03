pragma solidity ^0.8.0;

library Search {
    function indexOf(uint[] storage self, uint val)
    public
    view
    returns (uint)
    {
        for (uint i = 0; i < self.length; i++)
            if (self[i] == val) return i;
        return uint(int(-1));
    }
}

contract woFor{
    uint[] public arr;

    function append(uint val) public {
        arr.push(val);
    }

    function replace (uint _old, uint _new) public {
        uint index = Search.indexOf(arr, _old);
        if (index == uint(int(-1))) arr.push(_new);
        else arr[index] = _new;
    }

    function getArr () public view returns (uint[] memory) {
        return arr;
    }
}

/*contract wFor{
    using Search for uint[];

    uint[] public arr;

    function append(uint val) public {
        arr.push(val);
    }

    function replace (uint _old, uint _new) public {
        uint index = arr.indexOf(_old);
        if (index == uint(int(1))) arr.push(_new);
        else arr[index] = _new;
    }
}*/