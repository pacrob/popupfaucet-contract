// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "@openzeppelin/access/Ownable.sol";


contract Faucet is Ownable {

    constructor(address initialOwner) Ownable(initialOwner) {}

    mapping(bytes32 => uint256) public eventFunds;
    mapping(bytes32 => bool) public eventNameTaken;

    event PaymentReceived(bytes32 hashedCode, uint256 amount, address sender);
    event TopUpReceived(bytes32 hashedCode, uint256 amount, address sender);
    event DripSent(address recipient, uint256 amount);
    event LogData(bytes32 data);
    event LogBool(bool bool_data);

    function hashedEventCode(string calldata eventCode) private returns (bytes32) {
        return keccak256(abi.encodePacked(eventCode));
    }

    function seedFunds(string calldata eventCode) external payable {
        require(msg.value > 0, "No Ether sent");
        require(eventNameTaken[hashedEventCode(eventCode)] == false, "Event already exists");

        eventFunds[hashedEventCode(eventCode)] += msg.value;
        eventNameTaken[hashedEventCode(eventCode)] = true;

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

    function topUp(string calldata eventCode) external payable {
        require(msg.value > 0, "No Ether sent");
        require(this.eventNameAvailable(eventCode) == false, "Event has to be created already");

        eventFunds[hashedEventCode(eventCode)] += msg.value;

        emit TopUpReceived(hashedEventCode(eventCode), msg.value, msg.sender);
    }

    function eventNameAvailable(string calldata eventCode) external returns (bool) {
        return !eventNameTaken[hashedEventCode(eventCode)];
    }

    function eventFundsAvailable(string calldata eventCode) external returns (uint256) {
        return eventFunds[hashedEventCode(eventCode)];
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
