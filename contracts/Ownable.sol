// SPDX-License-Identifier: MIT
pragma solidity 0.8.14;

contract Ownable {
    address payable _owner;

    constructor() {
        _owner = payable(msg.sender);
    }

    modifier onlyOwner() {
        require(msg.sender == _owner, "you are not the owner");
        _;
    }

    function isOwner() public view returns (bool) {
        return (msg.sender == _owner);
    }
}