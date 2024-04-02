// SPDX-License-Identifier: MIT
pragma solidity 0.8.9;

contract Upupgrade {
    address private implementation;
    bool private Solved = false;

    constructor(address _implementation){
        implementation = _implementation;
    }

    receive() external payable { 
        payable(address(this)).transfer(msg.value);
    }

    fallback() external payable {
        (bool success, bytes memory data) = implementation.delegatecall(msg.data);
    }

    function t(address _account) internal pure returns (string memory) {
        bytes memory encoded = abi.encodePacked(_account);
        bytes1 firstByte = encoded[0];
        bytes1 lastByte = encoded[encoded.length - 1];
        return string(abi.encodePacked(_toHexString(firstByte), _toHexString(lastByte)));
    }

    function _toHexString(bytes1 _byte) internal pure returns (string memory) {
        bytes memory hexChars = "0123456789abcdef";
        bytes memory result = new bytes(2);
        result[0] = hexChars[uint8(_byte) >> 4];
        result[1] = hexChars[uint8(_byte) & 0x0f];
        return string(result);
    }

    function isEqual(string memory a, string memory b) internal pure returns (bool) {
        bytes memory aa = bytes(a);
        bytes memory bb = bytes(b);
        if (aa.length != bb.length) return false;
        for(uint i = 0; i < aa.length; i ++) {
            if(aa[i] != bb[i]) return false;
        }
 
        return true;
    }

    modifier isAdmin {
        require(isEqual(t(msg.sender), "cafe"),"You not Admin!!!");
        _;
    }

    function upgrade(address newImplementation) external isAdmin {
        implementation = newImplementation;
    }

    function isSolved() public view returns (bool){
        return Solved;
    }
}