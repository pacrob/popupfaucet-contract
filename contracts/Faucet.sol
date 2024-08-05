// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "@openzeppelin/access/Ownable.sol";


contract Faucet is Ownable {

    constructor(address initialOwner) Ownable(initialOwner) {}

    mapping(bytes32 => uint256) public eventFunds;

    event PaymentReceived(bytes32 hashedCode, uint256 amount, address sender);
    event DripSent(address recipient, uint256 amount);
    event LogData(bytes32 data);

    function hashedEventCode(string calldata eventCode) private returns (bytes32) {
        bytes32 data = keccak256(abi.encodePacked(eventCode));
        emit LogData(data);
        return data;
    }

    function seedFunds(string calldata eventCode) external payable {
        require(msg.value > 0, "No Ether sent");

        eventFunds[hashedEventCode(eventCode)] += msg.value;

        emit PaymentReceived(hashedEventCode(eventCode), msg.value, msg.sender);
    }

    function drip(address recipient, string calldata eventCode) external {

        uint256 dripAmount = 0.0001 ether;

        require(address(this).balance >= dripAmount, "Insufficient contract balance");
        require(eventFunds[hashedEventCode(eventCode)] >= dripAmount, "Insufficient event balance");

        eventFunds[hashedEventCode(eventCode)] -= dripAmount;
        payable(recipient).transfer(dripAmount);

        emit DripSent(recipient, dripAmount);
    }


    function withdraw() onlyOwner external {
        payable(msg.sender).transfer(address(this).balance);
    }

    receive() external payable {
        // Optional: you can handle direct transfers differently, but here we just accept it
    }

    fallback() external payable {
        // This fallback function will catch any non-existent function calls
    }
}
